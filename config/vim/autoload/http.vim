vim9script

var s:pending = {}

const s:nl = "\r\n"
const s:start = "%s %s HTTP/1.1" .. s:nl
const s:match_res = '\v^(HTTP/1\.[01])\s+(\d+)\s+(.*)$'
const s:match_header = '\v^([^:]+):\s*(.*)$'

const s:state_status = 0
const s:state_header = 1
const s:state_body = 2

const s:mime_json = {
	[false]: "application/json",
	[true]: "application/vscode-jsonrpc",
}

export def http#debug(res: dict<any>)
	if res->has_key('error')
		echohl Error | echom res.error | echohl None
		return
	endif
	if res->has_key('proto')
		echom res.proto .. ' ' .. res.status .. ' ' .. res.statusText
	endif
	for [key, val] in res.header->items()
		echom key .. ': ' .. val
	endfor
	echom res.body
enddef

export def http#get(ch: channel, url: string, response: func(dict<any>))
	http#request(ch, { url: url, method: 'GET', response: response })
enddef

export def http#post(ch: channel, url: string, body: any, response: func(dict<any>))
	http#request(ch, { url: url, method: 'POST', body: body, response: response })
enddef

export def http#request(ch: channel, req: dict<any> = {})
	ch->ch_setoptions({
		mode: 'raw',
		noblock: true,
		callback: function('s:pump'),
	})

	const info = ch->ch_info()
	const lsp = req->get('lsp', false)

	if !lsp
		var hdr = req->get('header', {})
		hdr['Host'] = hdr->get('Host', info.hostname) 
		req.header = hdr
	endif

	var recv = s:pending->get(info.id, http#recv_start(lsp))
	s:pending[info.id] = recv

	recv.callbacks->add(req->get('response', http#debug))

	http#send(ch, req)
enddef

export def http#send(ch: channel, req: dict<any> = {})
	const lsp = req->get('lsp', false)
	var body = req->get('body', '')
	var hdr = req->get('header', {})

	var ct = "text/plain"
	if type(body) != v:t_string
		body = body->json_encode()
		ct = s:mime_json[lsp]
	endif

	hdr['Content-Type'] = hdr->get('Content-Type', ct)
	hdr['Content-Length'] = len(body)

	var head = ''
	if !lsp
		const method = req->get('method', 'GET')
		const url = req->get('url', '/')
		head = printf(s:start, method, url)
	end

	for [key, val] in hdr->items()
		head ..= key .. ': ' .. val .. s:nl
	endfor
	head ..= s:nl

	ch->ch_sendraw(head)
	ch->ch_sendraw(body)
enddef

export def http#recv_start(lsp: bool = false): dict<any>
	var recv = { init: s:state_status, state: s:state_status, data: '', callbacks: [] }
	if lsp
		recv.init = s:state_header
		recv.state = s:state_header
		recv.json = true
	endif
	return recv
enddef

export def http#recv(ch: channel, recv: dict<any>, msg: string): list<dict<any>>
	var out = []

	var data = msg
	if len(recv.data) > 0
		data = recv.data .. data
	endif

	while len(data) > 0
		var resp = s:response_of(recv)

		if recv.state < s:state_body
			const idx = data->stridx(s:nl)
			if idx < 0
				break
			endif

			const value = data[0 : idx - 1]
			data = data[idx + 2 : -1]

			if recv.state == s:state_status
				if !s:parse_status(resp, value)
					out->add(recv->remove('response'))
					break
				end
				recv.state = s:state_header
			elseif idx == 0
				recv.state = s:state_body
			elseif !s:parse_header(resp, value)
				out->add(recv->remove('response'))
				break
			endif
		elseif len(data) >= resp.length
			resp.body = data[0 : resp.length - 1]
			data = data[resp.length : -1]

			if s:decode_json(recv, resp)
				resp.body = resp.body->json_decode()
			endif

			recv.state = recv.init

			out->add(recv->remove('response'))
		else
			break
		endif
	endwhile

	recv.data = data
	return out
enddef

def s:decode_json(recv: dict<any>, resp: dict<any>): bool
	if recv->has_key('json')
		return recv.json
	endif
	return resp.header->get('Content-Type', '') == 'application/json' 
enddef

def s:response_of(recv: dict<any>): dict<any>
	var resp = recv->get('response', { length: 0, status: 0, header: {} })
	recv.response = resp
	return resp
enddef

def s:pump(ch: channel, msg: string)
	const info = ch->ch_info()

	if !s:pending->has_key(info.id)
		return
	endif

	var recv = s:pending[info.id]
	var err = false
	
	for resp in http#recv(ch, recv, msg) 
		if len(recv.callbacks) == 0
			err = true
			break
		endif
		err = err || resp->has_key('error')
		recv.callbacks->remove(0)->call([resp])
	endfor

	if err
		s:close(ch, info.id)
	elseif len(recv.callbacks) == 0
		s:pending->remove(info.id)
	endif
enddef

def s:close(ch: channel, id: number)
	ch->ch_close()
	var recv = s:pending->remove(id)
	for callback in recv.callbacks
		callback->call([{ error: 'cancelled' }])
	endfor
enddef

def s:parse_status(resp: dict<any>, val: string): bool
	const vals = matchlist(val, s:match_res)
	if len(vals) == 0
		resp.error = "invalid status line"
		return false
	endif
	resp.proto = vals[1]
	resp.status = str2nr(vals[2])
	resp.statusText = vals[3]
	return true
enddef

def s:parse_header(resp: dict<any>, val: string): bool
	if match(val, '^\ctransfer-encoding: chunked$') == 0
		resp.error = "chunked encoding not supported"
		return false
	endif

	const vals = matchlist(val, s:match_header)
	if len(vals) == 0
		resp.error = "invalid header"
		return false
	endif

	if match(vals[1], '^\ccontent-length$') == 0
		resp.length = str2nr(vals[2], 10)
	endif

	resp.header[vals[1]] = vals[2]
	return true
enddef

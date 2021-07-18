vim9script

export def lsc#create(opts: dict<any> = {}): dict<any>
	var cmd = [opts.path]
	cmd->extend(opts->get('args', []))

	var workspace_file = opts->get('workspace_file', ['.git/config'])
	if type(workspace_file) != v:t_list
		workspace_file = [workspace_file]
	endif

	return {
		id: 0,
		job: v:none,
		status: "stopped",
		cmd: cmd,
		log_file: opts->get('log_file', "/tmp/vim-lsp.log"),
		workspaces: opts->get('workspaces', {}),
		workspace_file: workspace_file,
		callbacks: {},
		capabilities: {},
		events: {
			["response"]: function('s:unhandled_response'),
			["window/showMessage"]: function('s:show_message'),
			["window/logMessage"]: function('s:log_message'),
		},
	}
enddef

export def lsc#on(srv: dict<any>, ev: string, callback: func(dict<any>, dict<any>))
	srv.events[ev] = callback
enddef

export def lsc#add_buffer(srv: dict<any>, bnr: number = bufnr())
	const path = bufname(bnr)
	const furi = s:uri_of(path)
	const wsuri = s:workspace_uri(path, srv.workspace_file)

	var ws = srv.workspaces->get(wsuri, {})
	const init = empty(ws)

	const doc = {
		uri: furi,
		type: getbufvar(bnr, '&filetype'),
		bufnr: bnr,
	}

	ws[furi] = doc
	srv.workspaces[wsuri] = ws

	if srv.status == "running"
		if init
			s:workspaceDidChange(srv, [wsuri], [])
		endif
		s:textDocumentDidOpen(srv, doc)
	endif
enddef

export def lsc#remove_buffer(srv: dict<any>, bnr: number = bufnr())
	const path = bufname(bnr)
	const furi = s:uri_of(path),
	const wsuri = s:workspace_uri(path, srv.workspace_file)

	if !srv.workspaces->has_key(wsuri)
		return
	endif

	var ws = srv.workspaces[wsuri]
	if !ws->has_key(furi)
		return
	endif

	const doc = ws->remove(furi)
	if empty(ws)
		srv.workspaces->remove(wsuri)
	endif

	if srv.status == "running"
		s:textDocumentDidClose(srv, doc)
		if empty(ws)
			s:workspaceDidChange(srv, [], [wsuri])
		endif
	endif
enddef

export def lsc#start(srv: dict<any>): bool
	var job = job_start(srv.cmd, {
		in_mode: 'raw',
		out_mode: 'raw',
		err_mode: 'raw',
		noblock: 1,
		stoponexit: "term",
		out_cb: function('s:pump_out', [srv]),
		err_cb: function('s:pump_err', [srv]),
		exit_cb: function('s:exiting', [srv]),
	})

	if job->job_status() == 'fail'
		return false
	endif

	srv.job = job
	srv.status = "starting"

	s:initialize(srv)
	return true
enddef

export def lsc#send(srv: dict<any>, msg: dict<any>, cb: any = v:none)
	var ch = srv.job->job_getchannel()
  if ch_status(ch) == 'open'
		if msg->has_key('id')
			if cb == v:none
				if srv.callbacks->has_key(msg.id)
					srv.callbacks->remove(msg.id)
				endif
			else
				srv.callbacks[msg.id] = cb
			endif
		endif
		http#send(ch, { lsp: true, body: msg })
	else
		echohl Error | echo "not open" | echohl None
	endif
enddef

export def lsc#respond(srv: dict<any>, req: dict<any>, result: dict<any>)
	var msg = s:create_response(req.id)
	msg.result = result
	lsc#send(srv, msg)
enddef

export def lsc#respond_error(srv: dict<any>, req: dict<any>, error: dict<any>)
	var msg = s:create_response(req.id)
	msg.error = error
	lsc#send(srv, msg)
enddef

export def lsc#goto(srv: dict<any>, opts: dict<any>): bool
	const what = opts->get('what', 'definition')
	if !srv.capabilities->get(what .. 'Provider', v:false)
		return false
	endif

	const msg = s:create_request(srv, "textDocument/" .. what, {
		textDocument: { uri: s:uri_of(bufname(opts.bufnr)) },
		position: { line: opts.lnum - 1, character: opts.col - 1 }
	})

	lsc#send(srv, msg, function('s:goto_done', [opts]))

	return true
enddef

def s:goto_done(opts: dict<any>, srv: dict<any>, msg: dict<any>)
	var result = []
	for r in msg.result
		result->add({
			lnum: r.range.start.line + 1,
			col: r.range.start.character + 1,
			path: r.uri[len(s:uri_prefix) : -1],
		})
	endfor
	opts.callback(opts, result)
enddef

def s:pump(srv: dict<any>, ch: channel, recv: dict<any>, data: string)
	for resp in http#recv(ch, recv, data)
		var msg = resp.body
		var cb: any = v:none
		if msg->has_key('id')
			cb = srv.callbacks->get(msg.id, v:none)
			if type(cb) == v:t_none
				cb = srv.events->get("response", v:none)
			else
				srv.callbacks->remove(msg.id)
			endif
		else
			cb = srv.events->get(msg.method, v:none)
		endif
		if type(cb) != v:t_none
			cb->call([srv, msg])
		endif
	endfor
enddef

def s:pump_out(srv: dict<any>, ch: channel, data: string)
	var recv = srv->get('recv_out', http#recv_start(true))
	srv.recv_out = recv
	s:pump(srv, ch, recv, data)
enddef

def s:pump_err(srv: dict<any>, ch: channel, data: string)
	var recv = srv->get('recv_err', http#recv_start(true))
	srv.recv_err = recv
	s:pump(srv, ch, recv, data)
enddef

def s:exiting(srv: dict<any>, job: job, status: number)
	srv.job = v:none
	srv.runnine = false
	srv.exit_status = status
enddef

def s:create_request(srv: dict<any>, method: string, params: dict<any> = {}): dict<any>
	srv.id += 1
	return { jsonrpc: '2.0', id: srv.id, method: method, params: params }
enddef

def s:create_response(id: number): dict<any>
	return { jsonrpc: '2.0', id: id }
enddef

def s:create_notification(method: string, params: any = v:none): dict<any>
	var msg: dict<any> = { jsonrpc: '2.0', method: method }
	if type(params) != v:t_none
		msg.params = params
	endif
	return msg
enddef

def s:initialize(srv: dict<any>)
	const cwd = getcwd()

	var ws = []
	for uri in srv.workspaces->keys()
		ws->add(s:workspace_of(uri))
	endfor

	const msg = s:create_request(srv, 'initialize', {
		rootPath: cwd,
		rootUri: s:uri_of(cwd),
		processId: getpid(),
		clientInfo: {
			name: 'Vim',
			version: v:versionlong->string(),
		},
		workspaceFolders: ws,
		capabilities: {
			workspace: {
				workspaceFolders: true,
				applyEdit: true,
			},
			textDocument: {
				foldingRange: { lineFoldingOnly: true },
				completion: {
					completionItem: {
						documentationFormat: ['plaintext', 'markdown'],
						snippetSupport: false,
					},
					completionItemKind: { valueSet: range(1, 25) },
				},
				hover: {
					contentFormat: ['plaintext', 'markdown'],
				},
				documentSymbol: {
					hierarchicalDocumentSymbolSupport: true,
					symbolKind: { valueSet: range(1, 25) },
				},
			},
			window: {},
			general: {},
		},
		trace: 'off',
	})

	lsc#send(srv, msg, function('s:initialize_reply'))
enddef

def s:initialize_reply(srv: dict<any>, msg: dict<any>)
	srv.capabilities = msg.result.capabilities
	srv.status = "running"
	
	lsc#send(srv, s:create_request(srv, "initialized"), function("s:initialize_done"))
enddef
	
def s:initialize_done(srv: dict<any>, msg: dict<any>)
	for ws in srv.workspaces->values()
		for [bnr, doc] in ws->items()
			s:textDocumentDidOpen(srv, doc)
		endfor
	endfor
enddef

def s:textDocumentDidOpen(srv: dict<any>, doc: dict<any>)
	const msg = s:create_notification('textDocument/didOpen', {
		textDocument: {
			version: 1,
			uri: doc.uri,
			languageId: doc.type,
			text: getbufline(doc.bufnr, 1, '$')->join("\n") .. "\n"
		},
	})

	lsc#send(srv, msg)
enddef

def s:textDocumentDidClose(srv: dict<any>, doc: dict<any>)
	const msg = s:create_notification('textDocument/didClose', {
		textDocument: {
			uri: doc.uri,
		},
	})

	lsc#send(srv, msg)
enddef

def s:workspaceDidChange(srv: dict<any>, added: list<string>, removed: list<string>)
	var add = []
	for val in added
		add->add(s:workspace_of(val))
	endfor

	var rem = []
	for val in removed
		rem->add(s:workspace_of(val))
	endfor

	const msg = s:create_notification('workspace/didChangeWorkspaceFolders', {
		event: { added: add, removed: rem }
	})

	lsc#send(srv, msg)
enddef

def s:unhandled_response(srv: dict<any>, msg: dict<any>)
	echohl WarningMsg | echo "Unhandled response: " .. msg.id | echohl None
enddef

def s:show_message(srv: dict<any>, msg: dict<any>)
	echo msg.params.message
enddef

def s:log_message(srv: dict<any>, msg: dict<any>)
	writefile(msg.params.message->split("\r\n"), srv.log_file, "a")
enddef

const s:uri_prefix = "file://"

def s:uri_of(path: string): string
	return s:uri_prefix .. fnamemodify(path, ':p')
enddef

def s:workspace_path(path: string, search: list<string>): string
	const fpath = fnamemodify(path, ':p')

	if len(search) > 0
		var parent = fpath
		while parent != '/'
			parent = fnamemodify(parent, ':h')
			for subpath in search
				if filereadable(parent .. '/' .. subpath)
					return parent
				endif
			endfor
		endwhile
	endif

	const cwd = getcwd()
	if len(fpath) > len(cwd) && fpath[0 : len(cwd)] == cwd .. '/'
		return cwd
	endif

	return fnamemodify(fpath, ':h')
enddef

def s:workspace_uri(path: string, search: list<string>): string
	return s:uri_of(s:workspace_path(path, search))
enddef

def s:workspace_of(uri: string): dict<string>
	return { name: uri, uri: uri }
enddef


function! patch#apply_cmd(buf, cmd)
	let in = add(getbufline(a:buf, 1, '$'), "")
	let out = systemlist(a:cmd, in, 1)
	if v:shell_error != 0
		return out
	end
	call patch#apply_lines(a:buf, out)
	return []
endfunction

function! patch#apply_lines(buf, lines)
	let info = winsaveview()
	let hunks = patch#parse_lines(a:lines)
	let d = 0
	for hunk in hunks
		let hunk.f += d
		let hunk.t += d
		let [lnum, delta] = patch#apply_hunk(a:buf, hunk, info.lnum)
		let info.lnum = lnum
		let d += delta
	endfor
	if a:buf == '%'
		call winrestview(info)
	endif
endfunction

function! patch#apply_hunk(buf, hunk, lnum)
	let n = a:hunk.f
	let lnum = a:lnum
	let start = 0
	let len = 0
	let delta = 0
	for line in a:hunk.l
		if line[0] == '+'
			call appendbufline(a:buf, n-1, line[1:-1])
			if start == 0
				let start = n
			endif
			let len += 1
			let n += 1
			let delta += 1
		elseif line[0] == '-'
			call deletebufline(a:buf, n)
			if start == 0
				let start = n
			endif
			let len -= 1
			let delta -= 1
		else
			let n += 1
			if start <= lnum
				let lnum += len
				let start = 0
				let len = 0
			endif
		endif
	endfor
	if start <= lnum
		let lnum += len
		let start = 0
		let len = 0
	endif
	return [lnum, delta]
endfunction

function! patch#parse_lines(lines)
	let hunks = []
	for line in a:lines
		if line[0] == '@'
			" TODO: handling missing length and treat as 1
			let loc = matchlist(line, '^@@\s\+-\(\d\+\)\+,\(\d\+\)\s\++\(\d\+\)\+,\(\d\+\)\s\+@@$')
			if len(loc) == 0
				return []
			end
			let hunk = { 'f': str2nr(loc[1]), 'fl': str2nr(loc[2]), 't': str2nr(loc[3]), 'tl': str2nr(loc[4]), 'l': [] }
			call add(hunks, hunk)
		elseif line[0] != '\' && len(hunks) > 0
			call add(hunks[-1].l, line)
		endif
	endfor
	return hunks
endfunction

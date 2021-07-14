function! patch#apply_cmd(buf, cmd)
	let in = add(getbufline(a:buf, 1, '$'), "")
	let out = systemlist(a:cmd, in, 1)
	if v:shell_error != 0
		return out
	endif
	call patch#apply_lines(a:buf, out)
	return []
endfunction

function! patch#apply_lines(buf, lines)
	let hunks = patch#parse_lines(a:lines)
	call patch#apply_hunks(a:buf, hunks)
endfunction

function! patch#apply_hunks(buf, hunks)
	let info = winsaveview()

	for hunk in a:hunks
		let n = hunk.lnum
		if n <= info.lnum
			let info.lnum += len(hunk.add) - hunk.rem
		endif
		if hunk.rem
			call deletebufline(a:buf, n, n + hunk.rem - 1)
		endif
		if len(hunk.add)
			call appendbufline(a:buf, n-1, hunk.add)
		endif
	endfor

	if a:buf == '%'
		call winrestview(info)
	endif
endfunction

let s:hunk = '\v^\@\@\s*-(\d+)%[,(\d+)]\s*\+(\d+)%[,(\d+)]\s*\@\@$'

function! patch#parse_lines(lines)
	let hunk = { 'lnum': 0, 'add': [], 'rem': 0 }
	let hunks = [hunk]
	for line in a:lines
		let ch = line[0]
		if ch == '@'
			let loc = matchlist(line, s:hunk)
			if len(loc) == 0
				return []
			endif

			let lnum = str2nr(loc[1], 10) + len(hunk.add)
			if len(hunk.add) || hunk.rem
				let hunk = { 'lnum': lnum, 'add': [], 'rem': 0 }
				call add(hunks, hunk)
			else
				let hunk.lnum = lnum
			endif
		elseif hunk.lnum
			if ch == '+'
				call add(hunk.add, line[1:-1])
			elseif ch == '-'
				let hunk.rem += 1
			elseif ch == ' '
				if len(hunk.add) || hunk.rem
					let lnum = hunk.lnum + len(hunk.add) + 1
					let hunk = { 'lnum': lnum, 'add': [], 'rem': 0 }
					call add(hunks, hunk)
				else
					let hunk.lnum += 1
				endif
			endif
		endif
	endfor

	if len(hunk.add) == 0 && hunk.rem == 0
		call remove(hunks, -1)
	endif

	return hunks
endfunction

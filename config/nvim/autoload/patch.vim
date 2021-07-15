function! patch#apply_file(buf, file, prompt)
	let src = add(getbufline(a:buf, 1, '$'), "")
	call patch#apply(a:buf, readfile(a:file), src, a:prompt)
endfunction

function! patch#apply_cmd(buf, cmd, prompt)
	let src = add(getbufline(a:buf, 1, '$'), "")
	let diff = systemlist(a:cmd, src, 1)
	if v:shell_error != 0
		return diff
	endif
	call patch#apply(a:buf, diff, src, a:prompt)
	return []
endfunction

function! patch#apply(buf, diff, src, prompt)
	let hunks = patch#parse(a:diff, a:src)
	if len(hunks) > 0
		if a:prompt
			call patch#echo(a:diff)
			if !confirm("Apply?")
				return
			endif
		endif
		call patch#apply_hunks(a:buf, hunks)
	endif
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

let s:hunk = '\v^\@\@\s*-(\d+)%[,(\d+)]\s*\+(\d+)%[,(\d+)]\s*\@\@'

function! patch#parse(diff, src)
	let hunk = { 'lnum': 0, 'add': [], 'rem': 0 }
	let hunks = []
	let diffn = 1
	let ctx = 1
	for line in a:diff
		let ch = line[0]
		if ch == '@'
			let loc = matchlist(line, s:hunk)
			if len(loc) == 0
				return s:err("Malformed hunk", a:diff, diffn)
			endif

			let ctx = str2nr(loc[1], 10)
			let lnum = str2nr(loc[3], 10)
			if lnum <= hunk.lnum + len(hunk.add)
				return s:err("Hunk order invalid", a:diff, diffn)
			endif

			if len(hunk.add) || hunk.rem
				call add(hunks, hunk)
				let hunk = { 'lnum': lnum, 'add': [], 'rem': 0 }
			else
				let hunk.lnum = lnum
			endif
		elseif hunk.lnum
			if ch == '+'
				call add(hunk.add, line[1:-1])
			elseif ch == '-'
				let hunk.rem += 1
				let ctx += 1
			elseif ch == ' '
				if a:src[ctx-1] != line[1:-1]
					return s:err("Context match failed", a:diff, diffn)
				endif
				let ctx += 1
				if len(hunk.add) || hunk.rem
					call add(hunks, hunk)
					let lnum = hunk.lnum + len(hunk.add) + 1
					let hunk = { 'lnum': lnum, 'add': [], 'rem': 0 }
				else
					let hunk.lnum += 1
				endif
			endif
		endif
		let diffn += 1
	endfor

	if len(hunk.add) || hunk.rem
		call add(hunks, hunk)
	endif

	return hunks
endfunction

function! patch#echo(diff, ...)
	let lnum = get(a:, 1, 1) - 1
	let lend = get(a:, 2, len(a:diff))
	let lerr = get(a:, 3, -1)
	while lnum < lend
		let l = a:diff[lnum]
		let lnum += 1

		if lnum == lerr | echohl Error | else | echohl LineNr | endif
		echon printf(" %3d ", lnum)

		if l[0] == '@'
			echohl DiffText | echon l | echohl None
		elseif l[0] == '-'
			echohl DiffDelete | echon l | echohl None
		elseif l[0] == '+'
			echohl DiffAdd | echon l | echohl None
		else
			echohl None | echon l
		endif
		echon "\n"
	endwhile
endfunction

function! s:err(msg, diff, lnum)
	let lnum = a:lnum
	let lend = min([a:lnum + 2, len(a:diff)])
	while lnum > 1 && a:diff[lnum-1][0] != '@'
		let lnum -= 1
	endwhile

	echohl Error | echo a:msg."\n\n" | echohl None
	patch#echo(a:diff, lnum, lend, a:lnum)
	call confirm("Patch not applied")
	return []
endfunction


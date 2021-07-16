vim9script

export def patch#apply_file(bn: number, file: string, prompt = true): list<string>
	const src = getbufline(bn, 1, '$')->add("")
	patch#apply(bn, readfile(file), src, prompt)
enddef

export def patch#apply_cmd(bn: number, cmd: string, prompt = true): list<string>
	const src = getbufline(bn, 1, '$')->add("")
	const diff = systemlist(cmd, src)
	if v:shell_error != 0
		return diff
	endif
	patch#apply(bn, diff, src, prompt)
	return []
enddef

export def patch#apply(bn: number, diff: list<string>, src: list<string>, prompt = true): list<string>
	const hunks = patch#parse(diff, src)
	if len(hunks) > 0
		if prompt
			patch#echo(diff)
			if !confirm("Apply?")
				return []
			endif
		endif
		patch#apply_hunks(bn, hunks)
	endif
	return []
enddef

export def patch#apply_hunks(bn: number, hunks: list<dict<any>>)
	final info = winsaveview()

	for hunk in hunks
		const n = hunk.lnum
		if n <= info.lnum
			info.lnum += len(hunk.add) - hunk.rem
		endif
		if hunk.rem
			deletebufline(bn, n, n + hunk.rem - 1)
		endif
		if len(hunk.add) > 0
			appendbufline(bn, n - 1, hunk.add)
		endif
	endfor

	if bn == bufnr()
		winrestview(info)
	endif
enddef

const HUNK = '\v^\@\@\s*-(\d+)%[,(\d+)]\s*\+(\d+)%[,(\d+)]\s*\@\@'

export def patch#parse(diff: list<string>, src: list<string>): list<dict<any>>
	var hunk = { 'lnum': 0, 'add': [], 'rem': 0 }
	final hunks = []
	var diffn = 1
	var ctx = 1
	for line in diff
		const ch = line[0]
		if ch == '@'
			const loc = matchlist(line, HUNK)
			if len(loc) == 0
				s:err("Malformed hunk", diff, diffn)
				return []
			endif

			ctx = str2nr(loc[1], 10)
			const lnum = str2nr(loc[3], 10)
			if lnum <= hunk.lnum + len(hunk.add)
				s:err("Hunk order invalid", diff, diffn)
				return []
			endif

			if len(hunk.add) > 0 || hunk.rem > 0
				add(hunks, hunk)
				hunk = { 'lnum': lnum, 'add': [], 'rem': 0 }
			else
				hunk.lnum = lnum
			endif
		elseif hunk.lnum > 0
			if ch == '+'
				add(hunk.add, line[1 : -1])
			elseif ch == '-'
				hunk.rem += 1
				ctx += 1
			elseif ch == ' '
				if src[ctx - 1] != line[1 : -1]
					s:err("Context match failed", diff, diffn)
					return []
				endif
				ctx += 1
				if len(hunk.add) > 0 || hunk.rem > 0
					add(hunks, hunk)
					const lnum = hunk.lnum + len(hunk.add) + 1
					hunk = { 'lnum': lnum, 'add': [], 'rem': 0 }
				else
					hunk.lnum += 1
				endif
			endif
		endif
		diffn += 1
	endfor

	if len(hunk.add) > 0 || hunk.rem > 0
		add(hunks, hunk)
	endif

	return hunks
enddef

export def patch#echo(diff: list<string>, lnum = 1, lend = -1, lerr = -1)
	var n = lnum - 1
	var e = lend
	if e < 0
		e = len(diff) + e
	endif

	while n <= e
		const l = diff[n]
		n += 1

		if n == lerr | echohl Error | else | echohl LineNr | endif
		echon printf(" %3d ", n) | echohl None

		if l[0] == '@'
			echohl DiffText
		elseif l[0] == '-'
			echohl DiffDelete
		elseif l[0] == '+'
			echohl DiffAdd
		endif
		echon l | echohl None | echon "\n"
	endwhile
enddef

def s:err(msg: string, diff: list<string>, lnum: number)
	const lend = min([lnum + 2, len(diff)])
	var n = lnum
	while n > 1 && diff[n - 1][0] != '@'
		n -= 1
	endwhile

	echohl Error | echo msg | echo | echohl None

	patch#echo(diff, n, lend, lnum)
	confirm("Patch not applied")
enddef

vim9script

const parts = ["fg", "bg"]
const modes = ["gui", "cterm", "term"]
const attrs = ["bold", "italic", "reverse", "standout", "underline", "undercurl", "strikethrough"]

export def syntax#show(lnum = line('.'), col = col('.'))
	for id in synstack(lnum, col)
		syntax#echo(id)
	endfor
enddef

export def syntax#show_names(...globs: list<string>)
	for id in syntax#expand(globs)
		syntax#echo(id)
	endfor
enddef

export def syntax#echo(id: number)
	const rvals = syntax#resolve(id)
	echon printf("%-25S\t", rvals[1])
	exe printf("echohl %s", rvals[0]) | echon "xxx"

	for md in modes
		for clr in parts
			const val = synIDattr(rvals[2], clr, md)
			if len(val) > 0
				echohl Type   | echon printf(" %s%s", md, clr)
				echohl None   | echon "="
				echohl Number | echon val
			endif
		endfor

		var avals = []
		for attr in attrs
			if synIDattr(id, attr, md) == "1"
				avals->add(attr)
			endif
		endfor

		if len(avals) > 0
			echohl Type    | echon printf(" %s", md)
			echohl None    | echon "="
			echohl PreProc | echon join(avals, ",")
		endif
	endfor

	echohl None | echon "\n"
enddef

export def syntax#expand(globs: list<string>): list<number>
	var groups = []
	var ids = []
	for s in globs
		if match(s, '[\?\*\[\]]') == -1
			ids->add(hlID(s))
		else
			if len(groups) == 0
				groups = syntax#groups()
			endif
			const pat = glob2regpat(s)
			for g in groups
				if match(g, pat) != -1
					ids->add(hlID(g))
				endif
			endfor
		endif
	endfor
	return ids
enddef

export def syntax#resolve(id: number): list<any>
	var names = []
	var tid = id
	while true
		names->add(synIDattr(tid, "name"))
		const prev = tid
		tid = synIDtrans(prev)
		if prev == tid
			break
		endif
	endwhile
	return [names[0], join(names, " → "), tid]
enddef

export def syntax#groups(): list<string>
	const tmp = @z
	var result = []
	try
		redir @z
		silent highlight
		redir END
		result = split(@z, '\W[^\n]*\n')
	finally
		@z = tmp
	endtry
	return result
enddef

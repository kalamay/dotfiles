let s:colors = ["fg", "bg"]
let s:modes = ["gui", "cterm", "term"]
let s:attrs = ["bold", "italic", "reverse", "standout", "underline", "undercurl", "strikethrough"]

function! syntax#show(...)
	let lnum = get(a:, 1, line('.'))
	let col = get(a:, 2, col('.'))
	for id in synstack(lnum, col)
		call syntax#echo(id)
	endfor
endfunction

function! syntax#echo(...)
	for s in call("syntax#Expand", a:000)
		let [name, chain, id] = syntax#resolve(s)
		echon printf("%-25S\t", chain)
		exe printf("echohl %s", name) | echon "xxx"

		for md in s:modes
			for clr in s:colors
				let val = synIDattr(id, clr, md)
				if len(val) > 0
					echohl Type   | echon printf(" %s%s", md, clr)
					echohl None   | echon "="
					echohl Number | echon val
				endif
			endfor

			let attrs = []
			for attr in s:attrs
				if synIDattr(id, attr, md) == "1"
					call add(attrs, attr)
				endif
			endfor

			if len(attrs) > 0
				echohl Type    | echon printf(" %s", md)
				echohl None    | echon "="
				echohl PreProc | echon join(attrs, ",")
			endif
		endfor

		echohl None | echon "\n"
	endfor
endfunction

function! syntax#Expand(...)
	let groups = v:null
	let ids = []
	for s in a:000
		if type(s) == 0
			call add(ids, s)
		else
			if match(s, '[\?\*\[\]]') == -1
				call add(ids, hlID(s))
			else
				if type(groups) != 3
					let groups = syntax#groups()
				endif
				let pat = glob2regpat(s)
				for g in groups
					if match(g, pat) != -1
						call add(ids, hlID(g))
					endif
				endfor
			endif
		endif
	endfor
	return ids
endfunction

function! syntax#resolve(id)
	let names = []
	let id = a:id
	while 1
		call add(names, synIDattr(id, "name"))
		let prev = id
		let id = synIDtrans(prev)
		if prev == id
			break
		endif
	endwhile
	return [names[0], join(names, " → "), id]
endfunction

function! syntax#groups()
	let tmp = @z
	try
		redir @z
		silent highlight
		redir END
		return split(@z, '\W[^\n]*\n')
	finally
		let @z = tmp
	endtry
endfunction

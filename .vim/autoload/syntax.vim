function! syntax#Stack()
	" save register a
	let keep_rega= @a

	" get highlighting linkages into register "a"
	redir @a
	silent! hi
	redir END

	" initialize with top-level highlighting
	let firstlink = synIDattr(synID(line("."),col("."),1),"name")
	let lastlink  = synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
	let translink = synIDattr(synID(line("."),col("."),0),"name")

	" if transparent link isn't the same as the top highlighting link,
	" then indicate it with a leading "T:"
	if firstlink != translink
		let hilink= "T:".translink."->".firstlink
	else
		let hilink= firstlink
	endif

	" trace through the linkages
	if firstlink != lastlink
		let no_overflow= 0
		let curlink    = firstlink
		while curlink != lastlink && no_overflow < 10
			let no_overflow = no_overflow + 1
			let nxtlink     = substitute(@a,'^.*\<'.curlink.'\s\+xxx links to \(\a\+\).*$','\1','')
			if nxtlink =~ '\<start=\|\<cterm[fb]g=\|\<gui[fb]g='
				let nxtlink= substitute(nxtlink,'^[ \t\n]*\(\S\+\)\s\+.*$','\1','')
				let hilink = hilink ."->". nxtlink
				break
			endif
			let hilink      = hilink ."->". nxtlink
			let curlink     = nxtlink
		endwhile
	endif

	if v:version > 701 || ( v:version == 701 && has("patch215"))
		let syntaxstack = ""
		let isfirst     = 1
		let idlist      = synstack(line("."),col("."))
		if !empty(idlist)
			for id in idlist
				if isfirst
					let syntaxstack= syntaxstack." ".synIDattr(id,"name")
					let isfirst = 0
				else
					let syntaxstack= syntaxstack."->".synIDattr(id,"name")
				endif
			endfor
		endif
	endif

	" display hilink traces
	redraw
	let synid= hlID(lastlink)
	if !exists("syntaxstack")
		echo printf("Highlight: %s,  fg<%s> bg<%s>",hilink,synIDattr(synid,"fg"),synIDattr(synid,"bg"))
	else
		echo printf("Syntax:%s,  Highlight: %s,  fg<%s> bg<%s>",syntaxstack,hilink,synIDattr(synid,"fg"),synIDattr(synid,"bg"))
	endif

	" restore register a
	let @a= keep_rega
endfunction


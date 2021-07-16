vim9script

export def quickfix#start()
	setlocal nolist
	nnoremap <silent> <buffer> <CR> :call quickfix#select(line('.'))<CR>
	nnoremap <silent> <buffer> <C-C> :call quickfix#close()<CR>
enddef

export def quickfix#select(n: number)
	const info = getwininfo(win_getid())[0]
	if info.quickfix == "1"
		call execute("cc" . n)
	elseif info.loclist == "1"
		call execute("ll" . n)
	endif
enddef

export def quickfix#close()
	const info = getwininfo(win_getid())[0]
	if info.quickfix == "1"
		cclose
	elseif info.loclist == "1"
		lclose
	endif
enddef

function! quickfix#start()
	setlocal nolist
	nnoremap <silent> <buffer> <CR> :call quickfix#select(line('.'))<CR>
	nnoremap <silent> <buffer> <C-C> :call quickfix#close()<CR>
endfunction

function! quickfix#select(n)
	let info = getwininfo(win_getid())[0]
	if info.quickfix == "1"
		call execute("cc".a:n)
	elseif info.loclist == "1"
		call execute("ll".a:n)
	endif
endfunction

function! quickfix#close()
	let info = getwininfo(win_getid())[0]
	if info.quickfix == "1"
		cclose
	elseif info.loclist == "1"
		lclose
	endif
endfunction

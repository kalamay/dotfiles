function! reload#Vim()
	if exists("g:colors_name") && expand('%:t:r') == g:colors_name
		exe "colorscheme " . g:colors_name
	endif
endfunction

if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

command! -buffer GoFmt call GoFormat()
command! -buffer GoReferences lua vim.lsp.buf.references()
command! -buffer GoRename lua vim.lsp.buf.rename()

function! GoFormat()
	let err = []
	let out = patch#apply_cmd("%", "goimports -d")

	if len(out) > 0
		let buf = bufnr('%')
		for val in out
			let m = matchlist(val, '^\([^:]*\):\([^:]*\):\([^:]*\): \(.*\)$')
			if len(m) > 0
				call add(err, {'bufnr':buf,'lnum':str2nr(m[2]),'col':str2nr(m[3])-1,'text':m[4]})
			endif
		endfor
	endif

	call setloclist(0, err, 'r')
	call setloclist(0, [], 'a', {'title':'GoFmt'})
	if len(err) > 0
		if len(err) > 10
			lopen
		else
			call execute("lopen ".len(err))
		end
		return
	else
		lclose
	end
endfunction

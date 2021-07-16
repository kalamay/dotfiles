vim9script

if exists("b:did_ftplugin")
	finish
endif
b:did_ftplugin = 1

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

command! -buffer -bang GoFmt call <SID>fmt("<bang>" == "")
# command! -buffer GoReferences lua vim.lsp.buf.references()
# command! -buffer GoRename lua vim.lsp.buf.rename()

def s:fmt(prompt: bool)
	var err = []
	var out = patch#apply_cmd(bufnr(), "goimports -d", prompt)

	if len(out) > 0
		const buf = bufnr('%')
		for val in out
			const m = matchlist(val, '^\([^:]*\):\([^:]*\):\([^:]*\): \(.*\)$')
			if len(m) > 0
				call add(err, {'bufnr': buf, 'lnum': str2nr(m[2]), 'col': str2nr(m[3]) - 1, 'text': m[4]})
			endif
		endfor
	endif

	setloclist(0, err, 'r')
	setloclist(0, [], 'a', {'title': 'GoFmt'})
	if len(err) > 0
		if len(err) > 10
			lopen
		else
			execute("lopen " .. len(err))
		end
	else
		lclose
	end
enddef

vim9script

const s:gopls = $GOPATH .. '/bin/gopls'
const s:clangd = '/usr/local/opt/llvm/bin/clangd'

if executable(s:gopls)
	lsp#configure({
		filetype: ['go', 'gomod'],
		path: s:gopls,
		workspace_file: ['go.mod', '.git/config'],
	})
endif

if executable(s:clangd)
	lsp#configure({
		filetype: ['c', 'cpp'],
		path: s:clangd,
		args: ['--background-index'],
	})
endif

au BufWinEnter * call lsp#add_buffer()

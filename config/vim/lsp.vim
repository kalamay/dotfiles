vim9script

g:LSP_24x7_Complete = false

packadd lsp


lsp#addServer([{
			\ 'filetype': ['go', 'gomod'],
			\ 'path': $GOPATH .. '/bin/gopls',
			\ 'args': []
			\ }, {
			\ 'filetype': ['c', 'cpp'],
			\ 'path': '/usr/local/opt/llvm/bin/clangd',
			\ 'args': ['--background-index']
			\ }])

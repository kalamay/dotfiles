vim9script

g:LSP_24x7_Complete = false

packadd lsp

const s:gopls = $GOPATH .. '/bin/gopls'
const s:clangd = '/usr/local/opt/llvm/bin/clangd'

def s:start()
	var servers = []

	if executable(s:gopls)
		servers->add({ filetype: ['go', 'gomod'], path: s:gopls, args: [] })
	endif

	if executable(s:clangd)
		servers->add({ filetype: ['c', 'cpp'], path: s:clangd, args: ['--background-index'] })
	endif

	lsp#addServer(servers)
enddef

s:start()

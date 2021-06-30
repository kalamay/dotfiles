local cmd = vim.cmd
local opt = vim.opt
local lsp = vim.lsp

local indent = 4

opt.tabstop = indent
opt.shiftwidth = indent
opt.autoindent = true
opt.smartindent = true
opt.wrap = false
opt.backspace = { 'eol', 'start', 'indent' }
opt.undofile = true
opt.list = true
opt.listchars = "tab:⋅ ,eol:¬"
opt.fillchars = 'vert: ,fold:·'
opt.cursorline = true
opt.mouse = 'n'
opt.magic = true
opt.hidden = true
opt.showmatch = true
opt.gdefault = true
opt.shortmess = "filnxtToOFc"

opt.pumheight = 15
opt.completeopt = {'menuone', 'noinsert', 'noselect'}

opt.wildignore = {
	'*.o', '*.obj', '*.dSYM', '*.pyc',
	'.git', '.hg', '.svn', '.DS_Store',
	'tmp', 'node_modules'
}

cmd('colorscheme terminal')

cmd("autocmd BufEnter *.go lua enable_lsp()")
cmd("autocmd BufEnter *.c lua enable_lsp()")
cmd("autocmd BufWritePre *.go Fmt")

lsp.handlers["textDocument/publishDiagnostics"] = function() end

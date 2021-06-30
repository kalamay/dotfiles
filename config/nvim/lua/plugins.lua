local cmd = vim.cmd
local api = vim.api

cmd('packadd paq-nvim')

require('paq-nvim') {
	{'savq/paq-nvim', opt = true};
	'tpope/vim-vinegar';
	'mbbill/undotree';

	{'nvim-treesitter/nvim-treesitter', run=vim.fn[':TSUpdate'] };
	'nvim-treesitter/playground';

	'neovim/nvim-lspconfig';

	'nvim-lua/popup.nvim';
	'nvim-lua/plenary.nvim';
	'nvim-telescope/telescope.nvim';
}

local lspconfig = require('lspconfig')
lspconfig.gopls.setup{}
lspconfig.clangd.setup{}

function enable_lsp()
	api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
	api.nvim_buf_set_keymap(0, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
end

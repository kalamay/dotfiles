local cmd = vim.cmd
local api = vim.api

cmd('packadd paq-nvim')

require('paq-nvim') {
	{'savq/paq-nvim', opt = true};
	'tpope/vim-vinegar';
	'mbbill/undotree';
	'christoomey/vim-tmux-navigator';

	{'nvim-treesitter/nvim-treesitter', run=vim.fn[':TSUpdate'] };
	'nvim-treesitter/playground';

	'neovim/nvim-lspconfig';

	'nvim-lua/popup.nvim';
	'nvim-lua/plenary.nvim';
	'nvim-telescope/telescope.nvim';

	'dag/vim-fish';
}

local util = require('lspconfig/util')
local goroot = nil
local gopath = os.getenv("GOPATH") or ""
local gopathmod = gopath..'/pkg/mod'

local lspconfig = require('lspconfig')
lspconfig.clangd.setup{}
lspconfig.gopls.setup{
	root_dir = function(fname)
		local fullpath = vim.fn.expand(fname, ':p')
		if string.find(fullpath, gopathmod) and goroot ~= nil then
			return goroot
		end
		goroot = util.root_pattern("go.mod", ".git")(fname)
		return goroot
	end,
}

lsp = {}

function lsp:enable()
	api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
	api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
	api.nvim_buf_set_keymap(0, 'n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
end

require("telescope").setup{
	defaults = {
		layout_strategy = "vertical",
		layout_defaults = {
			vertical = {
				width_padding = 0.05,
				height_padding = 1,
				preview_height = 0.5,
			}
		},
		results_height = 10,
		set_env = { ['COLORTERM'] = 'truecolor' },
	}
}

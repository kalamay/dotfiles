local api = vim.api
local cmd = vim.cmd

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "'", "`")
map("n", "`", "'")

map("n", "]q", ":cnext<CR>")
map("n", "[q", ":cprevious<CR>")

map("n", "]l", ":lnext<CR>")
map("n", "[l", ":lprevious<CR>")

map("n", "<Leader>u", ":UndotreeToggle<CR>")

map("n", "<C-P>", ":Telescope find_files<CR>")

map("n", "<Space>", "za")
map("n", "<CR>", ":let @/=''<CR>", { silent = true })

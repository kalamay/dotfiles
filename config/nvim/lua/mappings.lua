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
map("n", "<C-B>", ":Telescope buffers<CR>")

map("n", "<Space>", "za")
map("n", "<CR>", ":let @/=''<CR>", { silent = true })

map("n", "<Leader>c", ':call syntax#show()<CR>')

cmd[[
	command! -nargs=+ -complete=highlight Hi call syntax#echo(<f-args>)
	command! -nargs=1 -complete=file -bang Patch call patch#apply_file('%', <q-args>, "<bang>" == "")
	command! -nargs=1 -complete=shellcmd -bang PatchCmd call patch#apply_cmd('%', <q-args>, "<bang>" == "")

	autocmd BufWinEnter * if &buftype == 'quickfix' | call quickfix#start() | endif"
]]


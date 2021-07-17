nnoremap ' `
nnoremap ` '

nnoremap <silent> <CR> :let @/=''<CR>

nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>

nnoremap ]l :lnext<CR>
nnoremap [l :lprevious<CR>

nnoremap <Leader>u :UndotreeToggle<CR>

nnoremap <c-]> :LspGotoDefinition<CR>

"nnoremap <C-P> :Telescope find_files<CR>
"nnoremap <C-B> :Telescope buffers<CR>

nnoremap <Leader>c :call syntax#show()<CR>

command! -nargs=+ -complete=highlight Hi call syntax#show_names(<f-args>)
command! -nargs=1 -complete=file -bang Patch call patch#apply_file(bufnr(), <q-args>, "<bang>" == "")
command! -nargs=1 -complete=shellcmd -bang PatchCmd call patch#apply_cmd(bufnr(), <q-args>, "<bang>" == "")

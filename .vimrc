set nocompatible
filetype off

if empty($BACKGROUND)
	set background=dark
else
	exec "set background=" + $BACKGROUND
endif

let c_no_curly_error = 1

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-fugitive'
if !has("gui_running")
	Plug 'christoomey/vim-tmux-navigator'
endif

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
nnoremap <Leader>u :UndotreeToggle<CR>

Plug 'tikhomirov/vim-glsl', { 'for': ['glsl'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }
Plug 'mxw/vim-jsx', { 'for': ['javascript'] }
Plug 'leafgarland/typescript-vim', { 'for': ['typescript'] }
Plug 'dag/vim-fish', { 'for': ['fish'] }
Plug 'hashivim/vim-terraform'

Plug 'evanleck/vim-svelte'

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries', 'for': ['go'] }
let g:go_highlight_diagnostic_errors = 0
let g:go_highlight_diagnostic_warnings = 0

Plug 'rust-lang/rust.vim', { 'for': ['rust'] }
Plug 'racer-rust/vim-racer'
let g:rustfmt_autosave = 1

"Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'objc', 'cc', 'cxx', 'cpp'] } 
"let s:clang_library_paths=[
"			\'/Library/Developer/CommandLineTools/usr/lib/libclang.dylib',
"			\'/usr/lib/llvm-5.0/lib/libclang.so.1',
"			\'/usr/lib/llvm-4.0/lib/libclang.so.1',
"			\'/usr/lib/llvm-3.5/lib/libclang.so.1']
"for path in s:clang_library_paths
"	if filereadable(path)
"		let g:clang_library_path=path
"		break
"	endif
"endfor

nnoremap <C-P> :call fzy#Command("pls", ":e")<CR>
" Plug 'liuchengxu/vim-clap', { 'do': ':Clap install-binary' }
" nnoremap <C-P> :Clap files<CR>

try
	set completeopt=menuone,noinsert
catch
	set completeopt=menuone
endtry
set pumheight=15

call plug#end()

filetype plugin indent on

source $VIMRUNTIME/macros/matchit.vim
source $VIMRUNTIME/ftplugin/man.vim

let s:swap_dir = $HOME . "/.vimswp"
if isdirectory(s:swap_dir)
	set directory=$HOME/.vimswp//
elseif exists("*mkdir")
	call mkdir(s:swap_dir)
	set directory=$HOME/.vimswp//
else
	set directory=/tmp//
endif

let s:undo_dir = $HOME . "/.vimundo"
if isdirectory(s:undo_dir)
	set undofile
	set undodir=$HOME/.vimundo//
elseif exists("*mkdir")
	call mkdir(s:undo_dir)
	set undofile
	set undodir=$HOME/.vimundo//
endif
au BufWritePre /Volumes/* setlocal noundofile

augroup WinActive
	autocmd!
	autocmd WinEnter * set cul
	autocmd WinLeave * set nocul
augroup END

set encoding=utf-8
set t_Co=256

set modeline
set modelines=5

" Sets how many lines of history VIM has to remember
set history=300

" switch the marker jumping commands
nnoremap ' `
nnoremap ` '

set cursorline
set scrolloff=2
set mouse=a

map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

"set number
set wildmenu
set hidden " change buffer - without saving

set showmatch " highligh matching brackets
set mat=2 " how many tenths of a second to blink

"set foldmethod=marker
"set foldmarker=*\ @{,/**\ @}\ */ " use doc @defgroup delimiters

set list
set listchars=tab:⋅\ ,eol:¬

set fillchars=vert:\ ,fold:·

" No sound on errors
set visualbell t_vb=

if has('gui_running')
	if has('mac')
		set fuoptions=maxvert,maxhorz
		set guifont=SF\ Mono\ Regular:h13
	else
		set guifont=Bitstream\ Vera\ Sans\ Mono:h10
	endif
	set guioptions=egma
	set guitablabel=%N\ %f
	set guioptions-=T
	set nolist
	set number
	colorscheme gruvbox
	nnoremap <D-S-Right> :tabnext<CR>
	nnoremap <D-S-Left> :tabprev<CR>
else
	colorscheme terminal
end

au BufNewFile,BufRead *.rl set filetype=ragel
au BufNewFile,BufRead *.conf set filetype=nginx
au BufNewFile,BufRead Capfile,Gemfile,Buildfile,*.ru,*.thor set filetype=ruby
au BufNewFile,BufRead *.m set filetype=objc
au BufNewFile,BufRead *.cikernel set filetype=glsl
au BufNewFile,BufRead *.kd set filetype=kd
au BufWritePost *.vim :call reload#Vim()

set fileformats=unix,dos,mac

syntax on

set viminfo='1000,f1,\"500,:100,/100
set sessionoptions=blank,buffers,curdir,folds,globals,help,localoptions,options,tabpages,winsize,winpos
set wildignore+=*.o,*.obj,*.dSYM,*.pyc,.git,.hg,.svn,.DS_Store,tmp,node_modules

set tabstop=2
set shiftwidth=2

set autoindent
set smartindent
set nowrap

set backspace=eol,start,indent
set whichwrap+=<,>

set hlsearch
set incsearch

set magic

" don't need /g after :s or :g
set gdefault

nnoremap <silent> <CR> :let @/=''<CR>

set laststatus=2

set statusline=%<%f%m%r\ %w\ %=Line\ %l\/%L,\ Col\ %02c,\ Code\ \%02B

inoremap <S-TAB> <C-X><C-O>

nnoremap <Space> za

" alternate and related files
nnoremap <silent> <Leader>a :A<CR>
nnoremap <silent> <Leader>r :R<CR>

let g:ft_man_open_mode = 'vert'
nnoremap K :exe ":Man -s2,3 " . expand('<cword>')<CR>

nmap <Leader>c :call syntax#Stack()<CR>


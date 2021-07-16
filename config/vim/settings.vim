set nocompatible
filetype off
filetype plugin indent on

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
set gdefault

set cursorline
set scrolloff=2
set sidescrolloff=8
set laststatus=2

set mouse=a

set showmatch
set mat=2

set list
set listchars=tab:⋅\ ,eol:¬
set fillchars=vert:\ ,fold:·

set number
set wildmenu
set hidden

set pumheight=15
set completeopt=menuone,noinsert,noselect

set wildignore+=*.o,*.obj,*.dSYM,*.pyc,.git,.hg,.svn,.DS_Store,tmp,node_module

set visualbell t_vb=

set undofile

syntax on

au BufWinEnter *.fish set filetype=fish
au BufWritePre *.go GoFmt!
au WinEnter * set cul
au WinLeave * set nocul
au BufWinEnter * if &buftype == 'quickfix' | call quickfix#start() | endif"
au BufWritePost *.vim :call reload#vim()

colorscheme nord

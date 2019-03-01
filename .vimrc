set nocompatible
filetype off

if empty($BACKGROUND)
	set background=dark
else
	exec "set background=" + $BACKGROUND
endif

let c_no_curly_error = 1

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'christoomey/vim-tmux-navigator'

Plug 'scrooloose/nerdtree'
let g:NERDTreeHijackNetrw=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeShowHidden=1
let g:NERDTreeShowLineNumbers=1
nnoremap <silent> <C-n> :edit .<CR>

Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
nnoremap <Leader>u :UndotreeToggle<CR>

"Plug 'beyondmarc/opengl.vim', { 'for': ['c', 'objc', 'cc', 'cxx', 'cpp'] }
Plug 'tikhomirov/vim-glsl', { 'for': ['glsl'] }
Plug 'rust-lang/rust.vim', { 'for': ['rust'] }
Plug 'pangloss/vim-javascript', { 'for': ['javascript'] }
Plug 'digitaltoad/vim-pug', { 'for': ['pug'] }

Plug 'dag/vim-fish'

Plug 'Rip-Rip/clang_complete', { 'for': ['c', 'objc', 'cc', 'cxx', 'cpp'] } 
let s:clang_library_paths=[
			\'/Library/Developer/CommandLineTools/usr/lib/libclang.dylib',
			\'/usr/lib/llvm-5.0/lib/libclang.so.1',
			\'/usr/lib/llvm-4.0/lib/libclang.so.1',
			\'/usr/lib/llvm-3.5/lib/libclang.so.1']
for path in s:clang_library_paths
	if filereadable(path)
		let g:clang_library_path=path
		break
	endif
endfor

function! FzyCommand(choice_command, vim_command)
	try
		let output = system(a:choice_command . " | fzy")
	catch /Vim:Interrupt/
		" Swallow errors from ^C, allow redraw! below
	endtry
	redraw!
	if v:shell_error == 0 && !empty(output)
		exec a:vim_command . ' ' . output
	endif
endfunction

nnoremap <C-P> :call FzyCommand("pls", ":e")<CR>

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

try
	set switchbuf=useopen,vsplit
catch
	set switchbuf=useopen
endtry
set splitright

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
		set guifont=SF\ Mono\ Regular:h12
	else
		set guifont=Bitstream\ Vera\ Sans\ Mono:h10
	endif
	set guioptions=egma
	set guitablabel=%N\ %f
	set guioptions-=T
	set nolist
	set number
	colorscheme srcery
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
au BufWritePost *.vim :call <SID>ReloadVim()

au BufNewFile,BufRead *.es set filetype=eros
au FileType eros setlocal shiftwidth=2 tabstop=2 expandtab
au FileType lisp setlocal shiftwidth=2 tabstop=2 expandtab

set fileformats=unix,dos,mac

"let g:nebula_termcolors = 16
"let g:nebula_contrast = 'high'
"let g:nebula_visibility = 'low'
"colorscheme nebula
"set background=dark

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

nmap <Leader>c :call <SID>SynStack()<CR>

function! <SID>ReloadVim()
	if exists("g:colors_name") && expand('%:t:r') == g:colors_name
		exe "colorscheme " . g:colors_name
	endif
endfunction

function! <SID>SynStack()
	" save register a
	let keep_rega= @a

	" get highlighting linkages into register "a"
	redir @a
	silent! hi
	redir END

	" initialize with top-level highlighting
	let firstlink = synIDattr(synID(line("."),col("."),1),"name")
	let lastlink  = synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
	let translink = synIDattr(synID(line("."),col("."),0),"name")

	" if transparent link isn't the same as the top highlighting link,
	" then indicate it with a leading "T:"
	if firstlink != translink
		let hilink= "T:".translink."->".firstlink
	else
		let hilink= firstlink
	endif

	" trace through the linkages
	if firstlink != lastlink
		let no_overflow= 0
		let curlink    = firstlink
		"   call Decho("loop#".no_overflow.": hilink<".hilink.">")
		while curlink != lastlink && no_overflow < 10
			let no_overflow = no_overflow + 1
			let nxtlink     = substitute(@a,'^.*\<'.curlink.'\s\+xxx links to \(\a\+\).*$','\1','')
			if nxtlink =~ '\<start=\|\<cterm[fb]g=\|\<gui[fb]g='
				let nxtlink= substitute(nxtlink,'^[ \t\n]*\(\S\+\)\s\+.*$','\1','')
				let hilink = hilink ."->". nxtlink
				break
			endif
			"    call Decho("loop#".no_overflow.": curlink<".curlink."> nxtlink<".nxtlink."> hilink<".hilink.">")
			let hilink      = hilink ."->". nxtlink
			let curlink     = nxtlink
		endwhile
		"   call Decho("endloop: hilink<".hilink.">")
	endif

	if v:version > 701 || ( v:version == 701 && has("patch215"))
		let syntaxstack = ""
		let isfirst     = 1
		let idlist      = synstack(line("."),col("."))
		if !empty(idlist)
			for id in idlist
				if isfirst
					let syntaxstack= syntaxstack." ".synIDattr(id,"name")
					let isfirst = 0
				else
					let syntaxstack= syntaxstack."->".synIDattr(id,"name")
				endif
			endfor
		endif
	endif

	" display hilink traces
	redraw
	let synid= hlID(lastlink)
	if !exists("syntaxstack")
		echo printf("Highlight: %s,  fg<%s> bg<%s>",hilink,synIDattr(synid,"fg"),synIDattr(synid,"bg"))
	else
		echo printf("Syntax:%s,  Highlight: %s,  fg<%s> bg<%s>",syntaxstack,hilink,synIDattr(synid,"fg"),synIDattr(synid,"bg"))
	endif

	" restore register a
	let @a= keep_rega
endfunction


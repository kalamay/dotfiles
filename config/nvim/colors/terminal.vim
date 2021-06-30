hi clear Normal

hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "terminal"

" Basic highlighting"{{{
" ---------------------------------------------------------------------
"
hi Constant ctermfg=5
hi String ctermfg=2
hi Character ctermfg=3
hi Number ctermfg=9
hi Boolean ctermfg=6
"       *Constant        any constant
"        String          a string constant: "this is a string"
"        Character       a character constant: 'c', '\n'
"        Number          a number constant: 234, 0xff
"        Boolean         a boolean constant: TRUE, false
"        Float           a floating point constant: 2.3e10

hi Identifier ctermfg=6
hi Function ctermfg=3
"       *Identifier      any variable name
"        Function        function name (also: methods for classes)

hi Statement ctermfg=10 cterm=bold
hi Conditional ctermfg=4 cterm=bold
hi link Label Conditional
hi link Repeat Conditional
"       *Statement       any statement
"        Conditional     if, then, else, endif, switch, etc.
"        Repeat          for, do, while, etc.
"        Label           case, default, etc.
"        Operator        "sizeof", "+", "*", etc.
"        Keyword         any other keyword
"        Exception       try, catch, throw

hi PreProc ctermfg=5 cterm=bold
hi Include ctermfg=5 cterm=bold
hi Define ctermfg=4 cterm=none
"       *PreProc         generic Preprocessor
"        Include         preprocessor #include
"        Define          preprocessor #define
"        Macro           same as Define
"        PreCondit       preprocessor #if, #else, #endif, etc.

hi Type ctermfg=14 cterm=bold
"       *Type            int, long, char, etc.
"        StorageClass    static, register, volatile, etc.
"        Structure       struct, union, enum, etc.
"        Typedef         A typedef

hi Special ctermfg=1 cterm=none
hi SpecialChar ctermfg=9 cterm=bold
hi Delimiter ctermfg=6
"       *Special         any special symbol
"        SpecialChar     special character in a constant
"        Tag             you can use CTRL-] on this
"        Delimiter       character that needs attention
"        SpecialComment  special things inside a comment
"        Debug           debugging statements

hi Underlined ctermfg=5 ctermbg=none cterm=none
"       *Underlined      text that stands out, HTML links

hi Ignore ctermfg=none ctermbg=none cterm=none
"       *Ignore          left blank, hidden  |hl-Ignore|

hi Error ctermfg=9 ctermbg=none cterm=bold,reverse
"       *Error           any erroneous construct

hi Todo ctermfg=9 ctermbg=none cterm=bold
"       *Todo            anything that needs extra attention; mostly the
"                        keywords TODO FIXME and XXX
"
"hi Directory"      .s:fmt_none   .s:fg_blue   .s:bg_none
hi WarningMsg ctermfg=11 ctermbg=none cterm=bold
"hi MoreMsg"        .s:fmt_none   .s:fg_blue   .s:bg_none
"hi ModeMsg"        .s:fmt_none   .s:fg_blue   .s:bg_none
"hi Question"       .s:fmt_bold   .s:fg_cyan   .s:bg_none
"hi Title"          .s:fmt_bold   .s:fg_orange .s:bg_none
"hi VisualNOS"      .s:fmt_stnd   .s:fg_none   .s:bg_base02 .s:fmt_revbb
"hi WildMenu"       .s:fmt_none   .s:fg_base2  .s:bg_base02 .s:fmt_revbb
hi link FoldColumn Folded
hi SignColumn ctermbg=none
"hi Conceal"        .s:fmt_none   .s:fg_blue   .s:bg_none
"hi SpellBad"       .s:fmt_curl   .s:fg_none   .s:bg_none    .s:sp_red
"hi SpellCap"       .s:fmt_curl   .s:fg_none   .s:bg_none    .s:sp_violet
"hi SpellRare"      .s:fmt_curl   .s:fg_none   .s:bg_none    .s:sp_cyan
"hi SpellLocal"     .s:fmt_curl   .s:fg_none   .s:bg_none    .s:sp_yellow
hi MatchParen     ctermfg=9 ctermbg=none cterm=bold
hi link lCursor Cursor
hi link vimGroup Constant

hi xmlTag ctermfg=7
hi xmlTagName ctermfg=5
hi xmlAttrib ctermfg=4
hi link xmlEndTag xmlTag

"}}}
" Conditional highlighting "{{{
" ---------------------------------------------------------------------
if &bg == "dark"
	hi Comment ctermfg=7
	hi SpecialKey ctermfg=8
	hi NonText ctermfg=8
	hi StatusLine ctermfg=15 ctermbg=0 cterm=bold
	hi StatusLineNC ctermfg=7 ctermbg=8 cterm=none
	hi Visual ctermbg=0
	hi IncSearch ctermfg=8 ctermbg=3 cterm=none term=none
	hi Search ctermfg=8 ctermbg=11 cterm=none term=none
	hi ErrorMsg ctermfg=0 ctermbg=1 cterm=bold
	hi LineNr ctermfg=0 ctermbg=none cterm=none
	hi VertSplit ctermbg=8 ctermfg=7 cterm=none
	hi Folded ctermfg=7 ctermbg=0 cterm=none
	hi DiffAdd ctermfg=2 ctermbg=7
	hi DiffChange ctermfg=3 ctermbg=7
	hi DiffDelete ctermfg=2 ctermbg=7
	hi DiffText ctermfg=4 ctermbg=7
	hi Pmenu ctermbg=7 ctermfg=8 cterm=none
	hi PmenuSel ctermbg=4 ctermfg=8 cterm=none
	hi PmenuSbar ctermbg=15
	hi PmenuThumb ctermbg=8
	hi TabLine ctermfg=7 ctermbg=8 cterm=none
	hi TabLineFill ctermfg=8 ctermbg=none
	hi TabLineSel ctermfg=none ctermbg=none cterm=bold
	hi CursorColumn ctermbg=8 cterm=none
	hi CursorLine ctermbg=8 cterm=none
	hi CursorLineNr ctermfg=12 ctermbg=8 cterm=none
	hi Cursor ctermbg=0 cterm=none
else
	hi Comment ctermfg=8
	hi SpecialKey ctermfg=15
	hi NonText ctermfg=15
	hi StatusLine ctermfg=0 ctermbg=7 cterm=none
	hi StatusLineNC ctermfg=8 ctermbg=15 cterm=none
	hi Visual ctermbg=7
	hi IncSearch ctermfg=15 ctermbg=3 cterm=none term=none
	hi Search ctermfg=15 ctermbg=11 cterm=none term=none
	hi ErrorMsg ctermfg=7 ctermbg=1 cterm=bold
	hi LineNr ctermfg=7 ctermbg=none cterm=none
	hi VertSplit ctermbg=15 ctermfg=0 cterm=none
	hi Folded ctermfg=7 ctermbg=0 cterm=none
	hi DiffAdd ctermfg=2 ctermbg=0
	hi DiffChange ctermfg=3 ctermbg=0
	hi DiffDelete ctermfg=2 ctermbg=0
	hi DiffText ctermfg=4 ctermbg=0
	hi Pmenu ctermbg=0 ctermfg=7 cterm=none
	hi PmenuSel ctermbg=4 ctermfg=15 cterm=none
	hi PmenuSbar ctermbg=15
	hi PmenuThumb ctermbg=7
	hi TabLine ctermfg=7 ctermbg=0 cterm=none
	hi TabLineFill ctermfg=0 ctermbg=none
	hi TabLineSel ctermfg=none ctermbg=none cterm=bold
	hi CursorColumn ctermbg=15 cterm=none
	hi CursorLine ctermbg=15 cterm=none
	hi CursorLineNr ctermfg=12 ctermbg=15 cterm=none
	hi Cursor ctermbg=7 cterm=none
endif
"}}}

vim9script

hi clear
if exists("syntax_on")
	syntax reset
endif

g:colors_name = "nord"

set background=dark

set t_8f=[38;2;%lu;%lu;%lum
set t_8b=[48;2;%lu;%lu;%lum
set termguicolors

const s:scheme = [
	#-+--- Polar Night ---+
	"#272b35", "#2e3440", "#3b4252", "#434c5e", "#4c566a", "#616E88",

	#-+--- Snow Storm ---+
	"#d8dee9", "#e5e9f0", "#eceff4",

	#-+--- Frost ---+
	"#8fbcbb", "#88c0d0", "#81a1c1", "#5e81ac",

	#-+--- Aurora ---+
	"#bf616a", "#d08770", "#ebcb8b", "#a3be8c", "#b48ead"
]

def s:hi(grp: string, fg: number = -1, bg: number = -1, ...attr: list<string>)
	var vals = ["hi ", grp]

	vals->add(" guifg=")
	if fg >= 0
		vals->add(s:scheme[fg])
	else
		vals->add("NONE")
	endif

	vals->add(" guibg=")
	if bg >= 0
		vals->add(s:scheme[bg])
	else
		vals->add("NONE")
	endif

	if len(attr) > 0
		vals->add(" cterm=")
		vals->add(attr->join(","))
	endif

	exec vals->join("")
enddef

#-+--- Editor ---+
s:hi("ColorColumn", -1, 2, "NONE")
s:hi("Cursor", 0, 6, "NONE")
s:hi("CursorLine", -1, 1, "NONE")
s:hi("CursorLineNR", 11, 1, "NONE")
s:hi("CursorColumn", -1, 1, "NONE")
s:hi("Error", 6, 13)
s:hi("iCursor", 0, 6)
s:hi("LineNr", 4, -1)
s:hi("MatchParen", 10, 4)
s:hi("NonText", 3, -1)
s:hi("Normal", 7, 0)
s:hi("Pmenu", 6, 3, "NONE")
s:hi("PmenuSbar", 6, 3)
s:hi("PmenuSel", 10, 4)
s:hi("PmenuThumb", 10, 4)
s:hi("SpecialKey", 2, -1)
s:hi("NonText", 2, -1)
s:hi("SpellBad", 13, 0, "underline")
s:hi("SpellCap", 15, 0, "underline")
s:hi("SpellLocal", 7, 0, "underline")
s:hi("SpellRare", 8, 0, "underline")
s:hi("Visual", -1, 3)
s:hi("VisualNOS", -1, 3)
hi link Whitespace NonText

#-+--- Navigation ---+
s:hi("Directory", 10, -1)

#-+--- Prompt/Status ---+
s:hi("EndOfBuffer", 2, -1)
s:hi("ErrorMsg", 6, 13)
s:hi("ModeMsg", 6, -1)
s:hi("MoreMsg", 10, -1)
s:hi("WarningMsg", 0, 15)
s:hi("WildMenu", 10, 2)
s:hi("Question", 6, -1)
s:hi("StatusLine", 4, 6)
s:hi("StatusLineNC", 3, 0)
s:hi("StatusLineTerm", 0, 0)
s:hi("StatusLineTermNC", 0, 0)
s:hi("StatusModeNormal", 0, 11, "bold")
s:hi("StatusModeInsert", 0, 16, "bold")
s:hi("StatusModeVisual", 0, 17, "bold")
s:hi("StatusModeReplace", 0, 13, "bold")
s:hi("StatusModeCommand", 0, 15, "bold")
s:hi("StatusFile", 6, 4)
s:hi("StatusMeta", 5, 2)
s:hi("StatusScroll", 11, 4)
s:hi("StatusModeNC", 0, 4)
s:hi("StatusFileNC", 0, 3)
s:hi("StatusMetaNC", 0, 2)
s:hi("StatusScrollNC", 0, 3)
hi link StatusModeSelect StatusModeVisual
hi link StatusModeTerm StatusModeCommand

#-+--- Search ---+
s:hi("IncSearch", 2, 14, "underline")
s:hi("Search", 2, 15, "NONE")
s:hi("QuickFixLine", 2, 10, "NONE")

#-+--- Tabs ---+
s:hi("TabLine", 6, 2, "NONE")
s:hi("TabLineFill", 6, 2, "NONE")
s:hi("TabLineSel", 10, 4, "NONE")

#-+--- Window ---+
s:hi("Title", 6, -1, "NONE")
s:hi("VertSplit", 3, 0, "NONE")

#-+--- Language ---+
s:hi("Boolean", 11, -1)
s:hi("Character", 16, -1)
s:hi("Comment", 5, -1)
s:hi("Conditional", 11, -1)
s:hi("Constant", 17, -1)
s:hi("Define", 11, -1)
s:hi("Delimiter", 8, -1)
s:hi("Exception", 11, -1)
s:hi("Float", 17, -1)
s:hi("Function", 10, -1)
s:hi("Identifier", 6, -1, "NONE")
s:hi("Include", 17, -1, "bold")
s:hi("Keyword", 15, -1)
s:hi("Number", 13, -1)
s:hi("Operator", 11, -1, "NONE")
s:hi("PreProc", 17, -1, "bold")
s:hi("Special", 9, -1)
s:hi("SpecialChar", 15, -1)
s:hi("SpecialComment", 10, -1)
s:hi("Statement", 11, -1, "bold")
s:hi("StorageClass", 11, -1)
s:hi("String", 16, -1)
s:hi("Structure", 11, -1)
s:hi("Tag", 6, -1)
s:hi("Todo", 0, 13, "bold")
s:hi("Type", 11, -1, "NONE")
s:hi("Typedef", 11, -1)
hi link Label Conditional
hi link Repeat Conditional
hi link Macro Define
hi link PreCondit PreProc

#-+--- Diff ---+
s:hi("DiffAdd", 16, 2)
s:hi("DiffChange", 15, 2)
s:hi("DiffDelete", 13, 2)
s:hi("DiffText", 11, 2)

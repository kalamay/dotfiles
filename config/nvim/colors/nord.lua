local cmd = vim.cmd
local g = vim.g
local set_hl = vim.api.nvim_set_hl

local nord = {
	--+--- Polar Night ---+
	"#2e3440", "#3b4252", "#434c5e", "#4c566a", "#616E88",

	--+--- Snow Storm ---+
	"#d8dee9", "#e5e9f0", "#eceff4",

	--+--- Frost ---+
	"#8fbcbb", "#88c0d0", "#81a1c1", "#5e81ac",

	--+--- Aurora ---+
	"#bf616a", "#d08770", "#ebcb8b", "#a3be8c", "#b48ead",

	--+--- Editor ---+
	ColorColumn         = {          bg = 1,  "NONE" },
	Cursor              = { fg = 0,  bg = 5,  "NONE" },
	CursorLine          = {          bg = 1,  "NONE" },
	CursorLineNR        = { fg = 10, bg = 1,  "NONE" },
	CursorColumn        = {          bg = 1,  "NONE" },
	Error               = { fg = 5,  bg = 12, },
	iCursor             = { fg = 0,  bg = 5,  },
	LineNr              = { fg = 3,           },
	MatchParen          = { fg = 9,  bg = 3,  },
	NonText             = { fg = 2,           },
	Normal              = { fg = 7,  bg = 0,  },
	Pmenu               = { fg = 5,  bg = 2,  "NONE" },
	PmenuSbar           = { fg = 5,  bg = 2,  },
	PmenuSel            = { fg = 9,  bg = 3,  },
	PmenuThumb          = { fg = 9,  bg = 3,  },
	SpecialKey          = { fg = 1,           },
	NonText             = { fg = 1,           },
	SpellBad            = { fg = 12, bg = 0,  "underline" },
	SpellCap            = { fg = 14, bg = 0,  "underline" },
	SpellLocal          = { fg = 6,  bg = 0,  "underline" },
	SpellRare           = { fg = 7,  bg = 0,  "underline" },
	Visual              = {          bg = 2,  },
	VisualNOS           = {          bg = 2,  },
	Whitespace          = "NonText",

	--+--- Navigation ---+
	Directory           = { fg = 9,           },

	--+--- Prompt/Status ---+
	EndOfBuffer         = { fg = 1,           },
	ErrorMsg            = { fg = 5,  bg = 12, },
	ModeMsg             = { fg = 5,           },
	MoreMsg             = { fg = 9,           },
	WarningMsg          = { fg = 0,  bg = 14, },
	WildMenu            = { fg = 9,  bg = 1,  },
	Question            = { fg = 5,           },
	StatusLine          = { fg = 0,  bg = 0,  },
	StatusLineNC        = { fg = 0,  bg = 0,  },
	StatusLineTerm      = { fg = 0,  bg = 0,  },
	StatusLineTermNC    = { fg = 0,  bg = 0,  },
	StatusModeNormal    = { fg = 0,  bg = 10, "bold" },
	StatusModeInsert    = { fg = 0,  bg = 15, "bold" },
	StatusModeVisual    = { fg = 0,  bg = 16, "bold" },
	StatusModeReplace   = { fg = 0,  bg = 12, "bold" },
	StatusModeCommand   = { fg = 0,  bg = 14, "bold" },
	StatusModeSelect    = "StatusModeVisual",
	StatusModeTerm      = "StatusModeCommand",
	StatusFile          = { fg = 5,  bg = 3,  },
	StatusMeta          = { fg = 4,  bg = 1,  },
	StatusScroll        = { fg = 10, bg = 3,  },
	StatusModeNC        = { fg = 0,  bg = 3,  },
	StatusFileNC        = { fg = 0,  bg = 2,  },
	StatusMetaNC        = { fg = 0,  bg = 1,  },
	StatusScrollNC      = { fg = 0,  bg = 2,  },

	--+--- Search ---+
	IncSearch           = { fg = 1,  bg = 13, "underline" },
	Search              = { fg = 1,  bg = 14, "NONE" },
	QuickFixLine        = { fg = 1,  bg = 9,  "NONE" },

	--"+--- Tabs ---+
	TabLine             = { fg = 5,  bg = 1,  "NONE" },
	TabLineFill         = { fg = 5,  bg = 1,  "NONE" },
	TabLineSel          = { fg = 9,  bg = 3,  "NONE" },

	--+--- Window ---+
	Title               = { fg = 5,           "NONE" },
	VertSplit           = { fg = 2,  bg = 0,  "NONE" },

	--+--- Language ---+
	Boolean             = { fg = 10,          },
	Character           = { fg = 15,          },
	Comment             = { fg = 4,           "italic" },
	Conditional         = { fg = 10,          },
	Constant            = { fg = 16,          },
	Define              = { fg = 10,          },
	Delimiter           = { fg = 7,           },
	Exception           = { fg = 10,          },
	Float               = { fg = 16,          },
	Function            = { fg = 9,           },
	Identifier          = { fg = 5,           "NONE" },
	Include             = { fg = 16,          "bold"},
	Keyword             = { fg = 15,          "bold"},
	Number              = { fg = 12,          },
	Operator            = { fg = 10,          "NONE" },
	PreProc             = { fg = 16,          "bold" },
	Special             = { fg = 8,           },
	SpecialChar         = { fg = 14,          },
	SpecialComment      = { fg = 9,           "italic" },
	Statement           = { fg = 10,          "bold" },
	StorageClass        = { fg = 10,          },
	String              = { fg = 15,          },
	Structure           = { fg = 10,          },
	Tag                 = { fg = 5,           },
	Todo                = { fg = 0,  bg = 12, "bold" },
	Type                = { fg = 10,          "NONE" },
	Typedef             = { fg = 10,          },
	Label               = "Conditional",
	Repeat              = "Conditional",
	Macro               = "Define",
	PreCondit           = "PreProc",

	--+--- Diff ---+
	DiffAdd             = { fg = 15, bg = 1,  },
	DiffChange          = { fg = 14, bg = 1,  },
	DiffDelete          = { fg = 12, bg = 1,  },
	DiffText            = { fg = 10, bg = 1,  },

	--+--- Treesitter Overrides ---+
	TSTypeBuiltin       = { fg = 16,          "NONE" },
}

g.terminal_color_0 = nord[1+1]
g.terminal_color_1 = nord[1+11]
g.terminal_color_2 = nord[1+14]
g.terminal_color_3 = nord[1+13]
g.terminal_color_4 = nord[1+9]
g.terminal_color_5 = nord[1+15]
g.terminal_color_6 = nord[1+8]
g.terminal_color_7 = nord[1+5]
g.terminal_color_8 = nord[1+3]
g.terminal_color_9 = nord[1+11]
g.terminal_color_10 = nord[1+14]
g.terminal_color_11 = nord[1+13]
g.terminal_color_12 = nord[1+9]
g.terminal_color_13 = nord[1+15]
g.terminal_color_14 = nord[1+7]
g.terminal_color_15 = nord[1+6]

local function render_hi(name, val, colors)
	if type(val) == "string" then
		return string.format('hi link %s %s', name, val)
	end

	local opts = ""
	for i,v in ipairs({"fg", "bg"}) do
		if val[v] ~= nil then
			local c = val[v]
			if type(c) == "number" then
				c = colors[c+1]
			end
			opts = opts..string.format(" gui%s=%s", v, c)
		end
	end

	local attrs = table.concat(val, ",")
	if attrs == "" then
		attrs = "nocombine"
	else 
		attrs = attrs .. ",nocombine"
	end

	return string.format('hi %s%s gui=%s', name, opts, attrs)
end

local function render(name, hi)
	local cmds = {"hi clear", "syntax reset", "set termguicolors"}
	for k, v in pairs(hi) do
		if type(k) == "string" then
			table.insert(cmds, render_hi(k, v, hi))
		end
	end
	cmd(table.concat(cmds, "\n"))
	g.colors_name = name
end

render("nord", nord)

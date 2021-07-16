local cmd = vim.cmd
local g = vim.g
local set_hl = vim.api.nvim_set_hl

local nord = {
	--+--- Polar Night ---+
	"#272b35", "#2e3440", "#3b4252", "#434c5e", "#4c566a", "#616E88",

	--+--- Snow Storm ---+
	"#d8dee9", "#e5e9f0", "#eceff4",

	--+--- Frost ---+
	"#8fbcbb", "#88c0d0", "#81a1c1", "#5e81ac",

	--+--- Aurora ---+
	"#bf616a", "#d08770", "#ebcb8b", "#a3be8c", "#b48ead",

	--+--- Editor ---+
	ColorColumn         = {          bg = 2,  "NONE" },
	Cursor              = { fg = 0,  bg = 6,  "NONE" },
	CursorLine          = {          bg = 1,  "NONE" },
	CursorLineNR        = { fg = 11, bg = 1,  "NONE" },
	CursorColumn        = {          bg = 1,  "NONE" },
	Error               = { fg = 6,  bg = 13, },
	iCursor             = { fg = 0,  bg = 6,  },
	LineNr              = { fg = 4,           },
	MatchParen          = { fg = 10, bg = 4,  },
	NonText             = { fg = 3,           },
	Normal              = { fg = 7,  bg = 0,  },
	Pmenu               = { fg = 6,  bg = 3,  "NONE" },
	PmenuSbar           = { fg = 6,  bg = 3,  },
	PmenuSel            = { fg = 10, bg = 4,  },
	PmenuThumb          = { fg = 10, bg = 4,  },
	SpecialKey          = { fg = 2,           },
	NonText             = { fg = 2,           },
	SpellBad            = { fg = 13, bg = 0,  "underline" },
	SpellCap            = { fg = 15, bg = 0,  "underline" },
	SpellLocal          = { fg = 7,  bg = 0,  "underline" },
	SpellRare           = { fg = 8,  bg = 0,  "underline" },
	Visual              = {          bg = 3,  },
	VisualNOS           = {          bg = 3,  },
	Whitespace          = "NonText",

	--+--- Navigation ---+
	Directory           = { fg = 10,          },

	--+--- Prompt/Status ---+
	EndOfBuffer         = { fg = 2,           },
	ErrorMsg            = { fg = 6,  bg = 13, },
	ModeMsg             = { fg = 6,           },
	MoreMsg             = { fg = 10,          },
	WarningMsg          = { fg = 0,  bg = 15, },
	WildMenu            = { fg = 10, bg = 2,  },
	Question            = { fg = 6,           },
	StatusLine          = { fg = 0,  bg = 0,  },
	StatusLineNC        = { fg = 0,  bg = 0,  },
	StatusLineTerm      = { fg = 0,  bg = 0,  },
	StatusLineTermNC    = { fg = 0,  bg = 0,  },
	StatusModeNormal    = { fg = 0,  bg = 11, "bold" },
	StatusModeInsert    = { fg = 0,  bg = 16, "bold" },
	StatusModeVisual    = { fg = 0,  bg = 17, "bold" },
	StatusModeReplace   = { fg = 0,  bg = 13, "bold" },
	StatusModeCommand   = { fg = 0,  bg = 15, "bold" },
	StatusModeSelect    = "StatusModeVisual",
	StatusModeTerm      = "StatusModeCommand",
	StatusFile          = { fg = 6,  bg = 4,  },
	StatusMeta          = { fg = 5,  bg = 2,  },
	StatusScroll        = { fg = 11, bg = 4,  },
	StatusModeNC        = { fg = 0,  bg = 4,  },
	StatusFileNC        = { fg = 0,  bg = 3,  },
	StatusMetaNC        = { fg = 0,  bg = 2,  },
	StatusScrollNC      = { fg = 0,  bg = 3,  },

	--+--- Search ---+
	IncSearch           = { fg = 2,  bg = 14, "underline" },
	Search              = { fg = 2,  bg = 15, "NONE" },
	QuickFixLine        = { fg = 2,  bg = 10, "NONE" },

	--"+--- Tabs ---+
	TabLine             = { fg = 6,  bg = 2,  "NONE" },
	TabLineFill         = { fg = 6,  bg = 2,  "NONE" },
	TabLineSel          = { fg = 10, bg = 4,  "NONE" },

	--+--- Window ---+
	Title               = { fg = 6,           "NONE" },
	VertSplit           = { fg = 3,  bg = 0,  "NONE" },

	--+--- Language ---+
	Boolean             = { fg = 11,          },
	Character           = { fg = 16,          },
	Comment             = { fg = 5,           "italic" },
	Conditional         = { fg = 11,          },
	Constant            = { fg = 17,          },
	Define              = { fg = 11,          },
	Delimiter           = { fg = 8,           },
	Exception           = { fg = 11,          },
	Float               = { fg = 17,          },
	Function            = { fg = 10,          },
	Identifier          = { fg = 6,           "NONE" },
	Include             = { fg = 17,          "bold"},
	Keyword             = { fg = 15,          },
	Number              = { fg = 13,          },
	Operator            = { fg = 11,          "NONE" },
	PreProc             = { fg = 17,          "bold" },
	Special             = { fg = 9,           },
	SpecialChar         = { fg = 15,          },
	SpecialComment      = { fg = 10,          "italic" },
	Statement           = { fg = 11,          "bold" },
	StorageClass        = { fg = 11,          },
	String              = { fg = 16,          },
	Structure           = { fg = 11,          },
	Tag                 = { fg = 6,           },
	Todo                = { fg = 0,  bg = 13, "bold" },
	Type                = { fg = 11,          "NONE" },
	Typedef             = { fg = 11,          },
	Label               = "Conditional",
	Repeat              = "Conditional",
	Macro               = "Define",
	PreCondit           = "PreProc",

	--+--- Diff ---+
	DiffAdd             = { fg = 16, bg = 2,  },
	DiffChange          = { fg = 15, bg = 2,  },
	DiffDelete          = { fg = 13, bg = 2,  },
	DiffText            = { fg = 11, bg = 2,  },

	--+--- Treesitter Overrides ---+
	TSTypeBuiltin       = { fg = 16,          "NONE" },
}

g.terminal_color_0 = nord[1+2]
g.terminal_color_1 = nord[1+12]
g.terminal_color_2 = nord[1+15]
g.terminal_color_3 = nord[1+14]
g.terminal_color_4 = nord[1+10]
g.terminal_color_5 = nord[1+16]
g.terminal_color_6 = nord[1+9]
g.terminal_color_7 = nord[1+6]
g.terminal_color_8 = nord[1+4]
g.terminal_color_9 = nord[1+12]
g.terminal_color_10 = nord[1+15]
g.terminal_color_11 = nord[1+14]
g.terminal_color_12 = nord[1+10]
g.terminal_color_13 = nord[1+16]
g.terminal_color_14 = nord[1+8]
g.terminal_color_15 = nord[1+7]

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

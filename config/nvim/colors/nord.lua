local cmd = vim.cmd
local g = vim.g
local set_hl = vim.api.nvim_set_hl

local nord = {
	--+--- Polar Night ---+
	"#2e3440", "#3b4252", "#434c5e", "#4c566a",

	--+--- Snow Storm ---+
	"#d8dee9", "#e5e9f0", "#eceff4",

	--+--- Frost ---+
	"#8fbcbb", "#88c0d0", "#81a1c1", "#5e81ac",

	--+--- Aurora ---+
	"#bf616a", "#d08770", "#ebcb8b", "#a3be8c", "#b48ead",

	--+--- Editor ---+
	ColorColumn         = {          bg = 1,  "NONE" },
	Cursor              = { fg = 0,  bg = 4,  "NONE" },
	CursorLine          = {          bg = 1,  "NONE" },
	CursorLineNR        = { fg = 4,  bg = 1,  "NONE" },
	CursorColumn        = {          bg = 1,  "NONE" },
	Error               = { fg = 4,  bg = 11, },
	iCursor             = { fg = 0,  bg = 4,  },
	LineNr              = { fg = 3,           },
	MatchParen          = { fg = 8,  bg = 3,  },
	NonText             = { fg = 2,           },
	Normal              = { fg = 5,  bg = 0,  },
	Pmenu               = { fg = 4,  bg = 2,  "NONE" },
	PmenuSbar           = { fg = 4,  bg = 2,  },
	PmenuSel            = { fg = 8,  bg = 3,  },
	PmenuThumb          = { fg = 8,  bg = 3,  },
	SpecialKey          = { fg = 1,           },
	NonText             = { fg = 1,           },
	SpellBad            = { fg = 11, bg = 0,  "undercurl" },
	SpellCap            = { fg = 13, bg = 0,  "undercurl" },
	SpellLocal          = { fg = 5,  bg = 0,  "undercurl" },
	SpellRare           = { fg = 6,  bg = 0,  "undercurl" },
	Visual              = {          bg = 2,  },
	VisualNOS           = {          bg = 2,  },

	--+--- Navigation ---+
	Directory           = { fg = 8,           },

	--+--- Prompt/Status ---+
	EndOfBuffer         = { fg = 1,           },
	ErrorMsg            = { fg = 4,  bg = 11, },
	ModeMsg             = { fg = 4,           },
	MoreMsg             = { fg = 8,           },
	Question            = { fg = 4,           },
  	StatusLine          = { fg = 8,  bg = 3,  "bold" },
  	StatusLineNC        = { fg = 2,  bg = 4,  "NONE" },
  	StatusLineTerm      = { fg = 8,  bg = 3,  "NONE" },
  	StatusLineTermNC    = { fg = 2,  bg = 4,  "NONE" },
	WarningMsg          = { fg = 0,  bg = 13, },
	WildMenu            = { fg = 8,  bg = 1,  },

	--+--- Search ---+
	IncSearch           = { fg = 1,  bg = 12, "underline" },
	Search              = { fg = 1,  bg = 13, "NONE" },


	--"+--- Tabs ---+
	TabLine             = { fg = 4, bg = 1,   "NONE" },
	TabLineFill         = { fg = 4, bg = 1,   "NONE" },
	TabLineSel          = { fg = 8, bg = 3,   "NONE" },

	--+--- Window ---+
	Title               = { fg = 4,           "NONE" },
	VertSplit           = { fg = 2, bg = 0,   "NONE" },

	--+--- Language ---+
	Boolean             = { fg = 9,           },
	Character           = { fg = 14,          },
	Comment             = { fg = 3,           "italic" },
	Conditional         = { fg = 9,           },
	Constant            = { fg = 4,           },
	Define              = { fg = 9,           },
	Delimiter           = { fg = 6,           },
	Exception           = { fg = 9,           },
	Float               = { fg = 15,          },
	Function            = { fg = 8,           },
	Identifier          = { fg = 4,           "NONE" },
	Include             = { fg = 9,           },
	Keyword             = { fg = 9,           },
	Label               = { fg = 9,           },
	Number              = { fg = 15,          },
	Operator            = { fg = 9,           "NONE" },
	PreProc             = { fg = 9,           "NONE" },
	Repeat              = { fg = 9,           },
	Special             = { fg = 4,           },
	SpecialChar         = { fg = 13,          },
	SpecialComment      = { fg = 8,           "italic" },
	Statement           = { fg = 9,           },
	StorageClass        = { fg = 9,           },
	String              = { fg = 14,          },
	Structure           = { fg = 9,           },
	Tag                 = { fg = 4,           },
	Todo                = { fg = 13,          },
	Type                = { fg = 9,           "NONE" },
	Typedef             = { fg = 9,           },
	Macro               = "Define",
	PreCondit           = "PreProc",

	--+--- Diff ---+
	DiffAdd             = { fg = 14, bg = 1,  },
	DiffChange          = { fg = 13, bg = 1,  },
	DiffDelete          = { fg = 11, bg = 1,  },
	DiffText            = { fg = 9,  bg = 1,  },
}

local function render_hi(name, val, colors)
	if type(val) == "string" then
		return string.format('hi link %s %s', name, val)
	end

	local opts = ""
	for i,v in ipairs({"fg", "bg"}) do
		if val[v] ~= nil then
			opts = opts..string.format(" gui%s=%s", v, colors[val[v]+1])
		end
	end

	local attrs = table.concat(val, ",")
	if attrs ~= "" and attrs ~= "NONE" then
		opts = opts..string.format(" gui=%s", attrs)
	end

	return string.format('hi %s%s', name, opts)
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

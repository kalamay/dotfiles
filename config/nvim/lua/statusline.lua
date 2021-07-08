local fn = vim.fn
local cmd = vim.cmd
local o = vim.o

cmd("autocmd WinEnter,BufEnter,BufDelete,SessionLoadPost,FileChangedShellPost * lua statusline:update()")

local fmt = '%%{%%v:lua.statusline.mode(v:%s)%%}%%#StatusFile%s# %%{v:lua.statusline.file()}%%m %%#StatusMeta%s#%%=%%{v:lua.statusline.meta()} %%#StatusScroll%s# %%l/%%L:%%02c %%0*'

function render_line(active)
	local type = active and "" or "NC"
	return string.format(fmt, active, type, type, type)
end

function render_mode(name, color)
	return {
		[true] = string.format('%%#StatusMode%s#%s', color, name),
		[false] = string.format('%%#StatusModeNC#%s', name),
	}
end

local modes = {
	['n']  = render_mode('  NORMAL  ', 'Normal' ),
	['i']  = render_mode('  INSERT  ', 'Insert' ),
	['R']  = render_mode(' REPLACE  ', 'Replace'),
	['v']  = render_mode('  VISUAL  ', 'Visual' ),
	['V']  = render_mode('  V-LINE  ', 'Visual' ),
	[''] = render_mode(' V-BLOCK  ', 'Visual' ),
	['c']  = render_mode(' COMMAND  ', 'Command'),
	['s']  = render_mode('  SELECT  ', 'Select' ),
	['S']  = render_mode('  S-LINE  ', 'Select' ),
	[''] = render_mode(' S-BLOCK  ', 'Select' ),
	['t']  = render_mode(' TERMINAL ', 'Term'   ),
}

local fallback_mode = render_mode('    ??    ', 'Normal')

local lines = {
	[true] = render_line(true),
	[false] = render_line(false),
}

local meta = { "fileformat", "fileencoding", "filetype" }

statusline = {}

function statusline.update()
	local w = fn.winnr()
	for i=1,fn.winnr('$') do
		fn.setwinvar(i, '&statusline', lines[i==w])
	end
end

function statusline.mode(active, mode)
	local m = modes[mode or fn.mode()] or fallback_mode
	return m[active]
end

function statusline.meta()
	local out = {}
	for i, name in ipairs(meta) do
		local val = o[name]
		if #val > 0 then
			table.insert(out, val)
		end
	end
	return table.concat(out, "・")
end

function statusline.file()
	local p = fn.expand('%:p')
	if #p > 0 then
		local cwd = fn.getcwd()..'/'
		if #p > #cwd and string.sub(p, 1, #cwd) == cwd then
			p = string.sub(p, #cwd+1)
		else
			local home = os.getenv("HOME")..'/'
			if #p > #home and string.sub(p, 1, #home) == home then
				p = '~/'..string.sub(p, #home+1)
			end
		end
	end
	return p
end

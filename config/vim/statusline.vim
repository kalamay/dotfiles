vim9script

const s:fmt = '%%{%%%smode(v:%s)%%}%%#StatusFile%s# %%{%sfile()}%%m %%#StatusMeta%s#%%=%%{%smeta()} %%#StatusScroll%s# %%l/%%L:%%02c %%0*'

def s:genline(active: bool): string
	const sid = expand('<SID>')
	var cur = ""
	if !active
		cur = "NC"
	endif
	return printf(fmt, sid, active, cur, sid, cur, sid, cur)
enddef

def s:genmode(name: string, color: string): dict<string>
	return {
		[true]: printf('%%#StatusMode%s#%s', color, name),
		[false]: printf('%%#StatusModeNC#%s', name),
	}
enddef

const s:modes = {
	['n']:  s:genmode('  NORMAL  ', 'Normal' ),
	['i']:  s:genmode('  INSERT  ', 'Insert' ),
	['R']:  s:genmode(' REPLACE  ', 'Replace'),
	['v']:  s:genmode('  VISUAL  ', 'Visual' ),
	['V']:  s:genmode('  V-LINE  ', 'Visual' ),
	['']: s:genmode(' V-BLOCK  ', 'Visual' ),
	['c']:  s:genmode(' COMMAND  ', 'Command'),
	['s']:  s:genmode('  SELECT  ', 'Select' ),
	['S']:  s:genmode('  S-LINE  ', 'Select' ),
	['']: s:genmode(' S-BLOCK  ', 'Select' ),
	['t']:  s:genmode(' TERMINAL ', 'Term'   ),
}

const s:fallback = s:genmode('    ??    ', 'Normal')

const s:lines = {
	[true]: s:genline(true),
	[false]: s:genline(false),
}

def s:update()
	const winn = winnr()
	const wine = winnr('$')
	var i = 1
	while i <= wine
		setwinvar(i, '&statusline', s:lines[i == winn])
		i += 1
	endwhile
enddef

def s:mode(active: bool): string
	return s:modes->get(mode(), s:fallback)[active]
enddef

def s:meta(): string
	return printf("%s・%s・%s", &fileformat, &fileencoding, &filetype)
enddef

def s:file(): string
	var out = expand('%:p')
	if len(out) > 0
		const cwd = getcwd() .. '/'
		if len(out) > len(cwd) && out[0 : len(cwd) - 1] == cwd
			out = out[len(cwd) : -1]
		elseif len(out) > len($HOME) && out[0 : len($HOME) - 1] == $HOME
			out = '~' .. out[len($HOME) : -1]
		end
	endif
	return out
enddef

au WinEnter,BufEnter,BufDelete,SessionLoadPost,FileChangedShellPost * call <SID>update()

s:update()

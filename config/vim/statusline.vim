vim9script

const s:fmt = '%%{%%g:StatuslineMode(%s)%%}%%#StatusFile%s# %%{g:StatuslineFile()}%%m %%#StatusMeta%s#%%=%%{g:StatuslineMeta()} %%#StatusScroll%s# %%l/%%L:%%02c %%0*'

def s:line(active: number): string
	var typ = ""
	if !active
		typ = "NC"
	endif
	return printf(fmt, active, typ, typ, typ)
enddef

def s:mode(name: string, color: string): list<string>
	return [ printf('%%#StatusModeNC#%s', name), printf('%%#StatusMode%s#%s', color, name)]
enddef

const s:modes = {
			\ ['n']:  s:mode('  NORMAL  ', 'Normal' ),
			\ ['i']:  s:mode('  INSERT  ', 'Insert' ),
			\ ['R']:  s:mode(' REPLACE  ', 'Replace'),
			\ ['v']:  s:mode('  VISUAL  ', 'Visual' ),
			\ ['V']:  s:mode('  V-LINE  ', 'Visual' ),
			\ ['']: s:mode(' V-BLOCK  ', 'Visual' ),
			\ ['c']:  s:mode(' COMMAND  ', 'Command'),
			\ ['s']:  s:mode('  SELECT  ', 'Select' ),
			\ ['S']:  s:mode('  S-LINE  ', 'Select' ),
			\ ['']: s:mode(' S-BLOCK  ', 'Select' ),
			\ ['t']:  s:mode(' TERMINAL ', 'Term'   ),
}

const s:fallback = s:mode('    ??    ', 'Normal')

const s:lines = [s:line(0), s:line(1)]

def g:StatuslineUpdate()
	const winn = winnr()
	const wine = winnr('$')
	var i = 1
	while i <= wine
		if i == winn
			setwinvar(i, '&statusline', s:lines[1])
		else
			setwinvar(i, '&statusline', s:lines[0])
		endif
		i += 1
	endwhile
enddef

def g:StatuslineMode(active: bool): string
	const m = s:modes->get(mode(), s:fallback)
	if active
		return m[1]
	else
		return m[0]
	endif
enddef

def g:StatuslineMeta(): string
	return [&fileformat, &fileencoding, &filetype]->join("・")
enddef

def g:StatuslineFile(): string
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

au WinEnter,BufEnter,BufDelete,SessionLoadPost,FileChangedShellPost * call StatuslineUpdate()

StatuslineUpdate()

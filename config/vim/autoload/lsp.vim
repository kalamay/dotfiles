vim9script

var s:config = {}

def s:lookup(bnr: number, init: bool = true): any
	const typ = getbufvar(bnr, '&filetype')
	if !s:config->has_key(typ)
		return v:none
	endif

	var cfg = s:config[typ]
	if !cfg->has_key('srv')
		if !init
			return v:none
		endif
		cfg.srv = lsc#create(cfg.opts)
		lsc#start(cfg.srv)
	endif

	return cfg.srv
enddef

export def lsp#configure(opts: dict<any>)
	for typ in opts->get('filetype', [])
		config[typ] = { opts: opts }
	endfor
enddef

export def lsp#add_buffer(bnr: number = bufnr())
	var srv = s:lookup(bnr)
	if type(srv) != v:t_none
		lsc#add_buffer(srv, bnr)
	endif
enddef

export def lsp#remove_buffer(bnr: number = bufnr())
	var srv = s:lookup(bnr, false)
	if type(srv) != v:t_none
		lsc#remove_buffer(srv, bnr)
	endif
enddef

export def lsp#goto(what: string = 'definition'): bool
	const bnr = bufnr()
	var srv = s:lookup(bnr)
	if type(srv) == v:t_none
		return false
	endif

	const pos = getcharpos('.')
	return lsc#goto(srv, {
		what: what,
		bufnr: bnr,
		lnum: pos[1],
		col: pos[2],
		callback: function('s:goto_done'),
	})
enddef

def s:goto_done(opts: dict<any>, result: list<dict<any>>)
	const pos = getcharpos('.')
	if len(result) == 0 || pos[1] != opts.lnum || pos[2] != opts.col
		return
	endif

	const cwd = getcwd() .. '/'
	const r = result[0]

	var cmd = "edit"
	if r.path[0 : len(cwd) - 1] != cwd
		cmd = "view"
	endif

  settagstack(winnr(), {
		items: [{
			bufnr: opts.bufnr,
			from: pos[1 : 2],
			matchnr: 1,
			tagname: expand('<cword>'),
		}]
	}, 't')

	exe printf("%s +call\\ setcursorcharpos(%d,\\ %d) %s", cmd, r.lnum, r.col, r.path)
enddef


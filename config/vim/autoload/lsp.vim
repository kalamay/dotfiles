vim9script

var s:config = {}

export def lsp#configure(opts: dict<any>)
	for typ in opts->get('filetype', [])
		config[typ] = { opts: opts }
	endfor
enddef

export def lsp#add_buffer(bnr: number = bufnr())
	const typ = getbufvar(bnr, '&filetype')
	if !s:config->has_key(typ)
		return
	endif

	var cfg = s:config[typ]
	if !cfg->has_key('srv')
		cfg.srv = lsc#create(cfg.opts)
		lsc#start(cfg.srv)
	endif

	lsc#add_buffer(cfg.srv, bnr)
enddef

export def lsp#remove_buffer(bnr: number = bufnr())
	const typ = getbufvar(bnr, '&filetype')
	if !s:config->has_key(typ)
		return
	endif

	var cfg = s:config[typ]
	if cfg->has_key('srv')
		lsc#remove_buffer(cfg.srv, bnr)
	endif
enddef

export def lsp#goto(what: string = 'definition'): bool
	const typ = getbufvar(bufnr(), '&filetype')
	if !s:config->has_key(typ)
		return false
	endif

	var cfg = s:config[typ]
	if !cfg->has_key('srv')
		cfg.srv = lsc#create(cfg.opts)
		lsc#start(cfg.srv)
	endif

	return lsc#goto(cfg.srv, what)
enddef


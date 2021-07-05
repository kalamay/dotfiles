if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal commentstring=//\ %s

command! -buffer GoFmt call GoFormat()

function! GoFormat()
  let winv = winsaveview()

  let lines = getline(1, '$')
  if &encoding != 'utf-8'
    let lines = map(lines, 'iconv(v:val, &encoding, "utf-8")')
  endif

  let err = []
  let out = systemlist('goimports', lines)

  if v:shell_error != 0
    let buf = bufnr('%')
    for idx in range(0, len(out)-1)
      let m = matchlist(out[idx], '^\([^:]*\):\([^:]*\):\([^:]*\): \(.*\)$')
      if len(m) > 0
        call add(err, {'bufnr':buf,'lnum':str2nr(m[2]),'col':str2nr(m[3])-1,'text':m[4]})
      endif
    endfor
  endif

  call setloclist(0, err, 'r')
  call setloclist(0, [], 'a', {'title':'GoFmt'})
  if len(err) > 0
    lopen
    return
  else
    lclose
  end

  call append(0, out)
  call deletebufline("%", len(out) + 1, "$")

  let line = lines[winv.lnum-1]
  let winv.lnum += len(out) - len(lines)
  let winv.col += len(out[winv.lnum-1]) - len(line)
  call winrestview(winv)

  syntax sync fromstart
endfunction

" vim:ts=2:sw=2:et

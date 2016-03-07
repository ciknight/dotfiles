" Status Function: {{{2
function! Status(winnum)
  let active = a:winnum == winnr()
  let bufnum = winbufnr(a:winnum)

  let stat = ''

  " this function just outputs the content colored by the
  " supplied colorgroup number, e.g. num = 2 -> User2
  " it only colors the input if the window is the currently
  " focused one

  function! Color(active, num, content)
    if a:active
      return '%' . a:num . '*' . a:content . '%*'
    else
      return a:content
    endif
  endfunction

  " this handles alternative statuslines
  let usealt = 0
  let altstat = Color(active, 4, ' »')

  let type = getbufvar(bufnum, '&buftype')
  let name = bufname(bufnum)

  if type ==# 'help'
    let altstat .= ' ' . fnamemodify(name, ':t:r')
    let usealt = 1
  elseif name ==# '__Gundo__'
    let altstat .= ' Gundo'
    let usealt = 1
  elseif name ==# '__Gundo_Preview__'
    let altstat .= ' Gundo Preview'
    let usealt = 1
  endif

  if usealt
    let altstat .= Color(active, 4, ' «')
    return altstat
  endif

  " column
  "   this might seem a bit complicated but all it amounts to is
  "   a calculation to see how much padding should be used for the
  "   column number, so that it lines up nicely with the line numbers

  "   an expression is needed because expressions are evaluated within
  "   the context of the window for which the statusline is being prepared
  "   this is crucial because the line and virtcol functions otherwise
  "   operate on the currently focused window

  function! Column()
    let vc = virtcol('.')
    let ruler_width = max([strlen(line('$')), (&numberwidth - 1)])
    let column_width = strlen(vc)
    let padding = ruler_width - column_width
    let column = ''

    if padding <= 0
      let column .= vc
    else
      " + 1 becuase for some reason vim eats one of the spaces
      let column .= repeat(' ', padding + 1) . vc
    endif

    return column . ' '
  endfunction

  " WTF are these?
  "let stat .= '%1*'
  "let stat .= '%{Column()}'
  "let stat .= '%*'

  " file name
  let stat .= Color(active, 4, active ? ' »' : ' «')
  let stat .= ' %<'
  let stat .= '%f'
  let stat .= ' ' . Color(active, 4, active ? '«' : '»')

  " file modified
  let modified = getbufvar(bufnum, '&modified')
  let stat .= Color(active, 2, modified ? ' +' : '')

  " read only
  let readonly = getbufvar(bufnum, '&readonly')
  let stat .= Color(active, 2, readonly ? ' ‼' : '')

  " paste
  if active && &paste
    let stat .= ' %2*' . 'P' . '%*'
  endif

  " right side
  let stat .= '%='

  " git branch
  if exists('*fugitive#head')
    let head = fugitive#head()

    if empty(head) && exists('*fugitive#detect') && !exists('b:git_dir')
      call fugitive#detect(getcwd())
      let head = fugitive#head()
    endif
  endif

  if !empty(head)
    let stat .= Color(active, 3, ' ←  ') . head . ' '
  endif

  return stat
endfunction
" }}}

" Status AutoCMD: {{{

function! s:RefreshStatus()
  for nr in range(1, winnr('$'))
    call setwinvar(nr, '&statusline', '%!Status(' . nr . ')')
  endfor
endfunction

augroup status
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * call <SID>RefreshStatus()
  autocmd VimEnter,WinEnter,BufWinEnter * highlight StatusLineNC ctermfg=15 ctermbg=8
  autocmd VimEnter,WinEnter,BufWinEnter * highlight StatusLine ctermfg=Yellow ctermbg=8
augroup END
" }}}
"
"highlight StatusLineNC ctermbg=13

" Status Colors: {{{
hi User1 ctermfg=33  ctermbg=15 
hi User2 ctermfg=125 ctermbg=8
hi User3 ctermfg=9  ctermbg=8
hi User4 ctermfg=10  ctermbg=8

"hi User1 ctermfg=33  guifg=#268bd2  ctermbg=15 guibg=#fdf6e3     blue, light
" used for far left number
"hi User2 ctermfg=125 guifg=#d33682  ctermbg=7  guibg=#eee8d5     berry, dark
"file status
"hi User3 ctermfg=64  guifg=#719e07  ctermbg=7  guibg=#eee8d5     green, dark
"arrow to right
"hi User4 ctermfg=37  guifg=#2aa198  ctermbg=7  guibg=#eee8d5     turq, dark
" <<>>

"hi User1 ctermfg=33  ctermbg=15
"hi User2 ctermfg=125 ctermbg=7
"hi User3 ctermfg=64  ctermbg=7
"hi User4 ctermfg=37  ctermbg=7

"hi User1 ctermfg=8  ctermbg=15
"hi User2 ctermfg=8  ctermbg=15
"hi User3 ctermfg=8  ctermbg=15
"hi User5 ctermfg=8  ctermbg=15
"hi User2 ctermfg=125 ctermbg=7
"hi User3 ctermfg=64  ctermbg=7
"hi User4 ctermfg=37  ctermbg=7

" }}}

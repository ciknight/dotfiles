"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Inspired by https://github.com/blaenk/dots/blob/master/vim/.vimrc "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

hi StatusLine guibg=#3d3d3d
hi StatusLineNC guibg=#3d3d3d
hi SLArrows guifg=#99cc99 guibg=#3d3d3d
hi SLColumn guibg=#3d3d3d
hi SLLineNr guifg=#cc99cc guibg=#3d3d3d
hi SLBranch guifg=#cc99cc guibg=#3d3d3d
hi SLProgress guibg=#3d3d3d
hi SLHelp guibg=#3d3d3d

function! Status(winnum)
  let active = a:winnum == winnr()
  let bufnum = winbufnr(a:winnum)

  let stat = ''

  " this function just outputs the content colored by the
  " supplied colorgroup number, e.g. num = 2 -> User2
  " it only colors the input if the window is the currently
  " focused one

  function! Color(active, group, content)
    if a:active
      return '%#' . a:group . '#' . a:content . '%*'
    else
      return a:content
    endif
  endfunction

  " this handles alternative statuslines
  let usealt = 0

  let type = getbufvar(bufnum, '&buftype')
  let name = bufname(bufnum)

  let altstat = ''

  if type ==# 'help'
    let altstat .= '%#SLHelp# HELP %* ' . fnamemodify(name, ':t:r')
    let usealt = 1
  elseif name ==# '__Gundo__'
    let altstat .= ' Gundo'
    let usealt = 1
  elseif name ==# '__Gundo_Preview__'
    let altstat .= ' Gundo Preview'
    let usealt = 1
  endif

  if usealt
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
    let ruler_width = max([strlen(line('$')), (&numberwidth - 1)]) + &l:foldcolumn
    let padding = ruler_width
    let column = ''

    " + 1 because for some reason vim eats one of the spaces
    let column .= repeat(' ', padding + 1)

    return column . ' '
  endfunction

  let stat .= '%#SLColumn#'
  let stat .= '%{Column()}'
  let stat .= '%*'

  if getwinvar(a:winnum, 'statusline_progress', 0)
    let stat .= Color(active, 'SLProgress', ' %p ')
  endif

  " file name
  let stat .= Color(active, 'SLArrows', active ? ' »' : ' «')
  let stat .= ' %<'
  let stat .= '%f'
  let stat .= ' ' . Color(active, 'SLArrows', active ? '«' : '»')

  " file modified
  let modified = getbufvar(bufnum, '&modified')
  let stat .= Color(active, 'SLLineNr', modified ? ' +' : '')

  " read only
  let readonly = getbufvar(bufnum, '&readonly')
  let stat .= Color(active, 'SLLineNR', readonly ? ' ‼' : '')

  " paste
  if active
    if getwinvar(a:winnum, '&spell')
      let stat .= Color(active, 'SLLineNr', ' S')
    endif

    if getwinvar(a:winnum, '&paste')
      let stat .= Color(active, 'SLLineNr', ' P')
    endif
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
    let stat .= Color(active, 'SLBranch', ' ← ') . head . ' ' . '%L '
  endif

  return stat
endfunction

function! s:ToggleStatusProgress()
  if !exists('w:statusline_progress')
    let w:statusline_progress = 0
  endif

  let w:statusline_progress = !w:statusline_progress
endfunction

command! ToggleStatusProgress :call s:ToggleStatusProgress()

nnoremap <silent> ,p :ToggleStatusProgress<CR>

function! s:IsDiff()
  let result = 0

  for nr in range(1, winnr('$'))
    let result = result || getwinvar(nr, '&diff')

    if result
      return result
    endif
  endfor

  return result
endfunction

function! s:RefreshStatus()
  for nr in range(1, winnr('$'))
    call setwinvar(nr, '&statusline', '%!Status(' . nr . ')')
  endfor
endfunction

command! RefreshStatus :call <SID>RefreshStatus()

augroup status
  autocmd!
  autocmd VimEnter,VimLeave,WinEnter,WinLeave,BufWinEnter,BufWinLeave * :RefreshStatus
augroup END

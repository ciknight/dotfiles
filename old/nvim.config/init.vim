call plug#begin('~/.config/nvim/plugs')

" essentials
Plug 'kien/ctrlp.vim'
Plug 'rking/ag.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'benekastah/neomake'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'amix/vim-zenroom'

" colors
Plug 'chriskempson/tomorrow-theme', {'rtp': 'vim' }

call plug#end()

syntax enable

colorscheme tomorrow-night-eighties

set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set expandtab        " tabs are spaces

set number              " show line numbers

set cursorline          " highlight current line

filetype indent on      " load filetype-specific indent files

set wildmenu            " visual autocomplete for command menu
set lazyredraw          " only 'typed' actions trigger a redraw
set ttyfast             " some sort of optimization for terminal vim
set showmatch           " highlight matching [{()}]
set incsearch           " search as characters are entered
set hlsearch            " highlight matches

set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set writebackup

" AutoComands {{{
augroup filetype_js
    autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
    autocmd FileType javascript setlocal omnifunc=tern#Complete
augroup END

augroup filetype_html
    autocmd Filetype html setlocal ts=4 sts=4 sw=4
augroup END

augroup filetype_css
    autocmd Filetype css setlocal ts=2 sts=2 sw=2
augroup END

augroup markdown
 au! BufRead,BufNewFile *.mkd   setfiletype mkd
augroup END
augroup filetype_mkd
    autocmd Filetype mkd setlocal ts=4 sts=4 sw=4
augroup END

" }}}

" Navigation {{{

" turn off search highlight
nnoremap <leader>th :nohlsearch<CR>

" move vertically by visual line (helps for wrapping)
nnoremap j gj
nnoremap k gk

" Window Navigation
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

" }}}

" Editing {{{

" open last buffer (nice for moving in and out of term)
nmap <tab> :b#<cr>

" No 'Ex mode'
nnoremap Q <nop>

let mapleader = ','
let maplocalleader = '\\'
inoremap jj <ESC>

" thanks vi
nnoremap Y y$

" }}}

" Plugins {{{

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

nnoremap <leader>a :Ag 

"NERDCommenter
let g:NERDCustomDelimiters = {
    \ 'javascript': { 'left': '// ' }
    \ }

" Pymode
let g:pymode_lint = 0
let g:pymode_python = 'python3'
let g:pymode_virtualenv_path = $VIRTUAL_ENV
let g:pymode_rope_goto_definition_cmd = 'e'
set nofoldenable  " don't fold by default

" Neomake
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_open_list = 0
autocmd! BufWritePost * Neomake

" }}}
 
" Neovim {{{

if has('nvim')
    " backtick sends true escape
    tnoremap ` <Esc>
    " terminal mode escapes just like insert mode
    tnoremap jj <C-\><C-n>
    " quickly enter term
    nnoremap <leader><leader> :term<cr>
    au WinEnter *pid:* call feedkeys('i')
endif

" }}}

" Reload vim config
autocmd bufwritepost init.vim source ~/.config/nvim/init.vim
autocmd bufwritepost settings.vim source ~/.config/nvim/init.vim
autocmd bufwritepost plugins.vim source ~/.config/nvim/init.vim
autocmd bufwritepost plugin-specific.vim source ~/.config/nvim/init.vim

" Leaders
let mapleader = ','
let maplocalleader = '\\'

" allow quit/save via single keypress
noremap <leader>q :q<CR>
noremap <leader>w :w<CR>
inoremap jj <ESC>

" Window Navigation
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <c-h> <c-w>h

" Inserting empty lines
nnoremap <Enter> o<ESC>
nnoremap <S-Enter> O<ESC>

" No 'Ex mode'
nnoremap Q <nop>

" remove search highlighting
nnoremap <leader>th :nohlsearch<CR>


" Random
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

" Colors
"set background=light
"colorscheme solarized
"
"let g:solarized_termcolors=256
"let g:solarized_termtrans=0
"let g:solarized_contrast="normal"
"let g:solarized_visibility="normal"

"syntax enable
"colorscheme solarized
"let g:solarized_termcolors=256
"set background=dark
"highlight clear SignColumn
"set t_Co=256

" Filetype-based autocommands
augroup filetype_js
    autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
augroup END

augroup filetype_html
    autocmd Filetype html setlocal ts=4 sts=4 sw=4
augroup END

augroup filetype_css
    autocmd Filetype css setlocal ts=2 sts=2 sw=2
augroup END

" omnifuncs
augroup omnifuncs
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

autocmd FileType javascript setlocal omnifunc=tern#Complete
" tern
"if exists('g:plugs["tern_for_vim"]')
  "let g:tern_show_argument_hints = 'on_hold'
  "let g:tern_show_signature_in_pum = 1

  "autocmd FileType javascript setlocal omnifunc=tern#Complete
"endif



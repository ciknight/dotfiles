set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
syntax on

" leader key
let mapleader = ','

" Pathogen 
filetype off
call pathogen#infect()
call pathogen#helptags()

" turn filetype on
filetype on
filetype plugin indent on    " enable loading indent file for filetype

" Solarized colors
syntax enable
let g:solarized_termcolors=256
set background=dark
colorscheme solarized
set t_Co=256                        " force vim to use 256 colors

autocmd FileType html :setlocal sw=2 ts=2 sts=2 " Two spaces for HTML files "
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd Filetype ruby setlocal ts=2 sts=2 sw=2

" Better copy & paste
" When you want to paste large blocks of code into vim, press F2 before you
" paste. At the bottom you should see ``-- INSERT (paste) --``.
set pastetoggle=<F2>
set clipboard=unnamed

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

" Inserting empty lines
map <Enter> o<ESC>
map <S-Enter> O<ESC>

" Insert -> normal mode
imap jj <ESC>

" relative line numbers
set relativenumber
set number

" Code Folding
set foldmethod=indent
set foldlevel=99

" Window Splitting
map <c-j> <c-w>j        " simplify switching windows
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" hotkey collision
map <leader>td <Plug>TaskList


" default directory for custom snippets
let g:snippets_dir = "~/.vim/snippets"

" tab completion
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"
set completeopt=menuone,longest,preview

" search
set hlsearch

" Gundo
map <leader>g :GundoToggle<CR>

" linting
let g:pyflakes_use_quickfix = 0
let g:pep8_map='<leader>8'

" NERD Tree file browser
map <leader>n :NERDTreeToggle<CR>

" Ack fuzzy text search
nmap <leader>a <Esc>:Ack!

" git and fugitive integration
"statusline += %{fugitive#statusline()}

""""""""""""""""""""""""""""""
" airline
""""""""""""""""""""""""""""""
let g:airline_theme             = 'jellybeans'
let g:airline_enable_branch     = 1
let g:airline_enable_syntastic  = 1
let g:airline_powerline_fonts   = 1

" vim-powerline symbols
let g:airline_left_sep          = '[]'
let g:airline_left_alt_sep      = '[]'
let g:airline_right_sep         = '[]'
let g:airline_right_alt_sep     = '[]'
let g:airline_branch_prefix     = '[]'
let g:airline_readonly_symbol   = '[]'
let g:airline_linecolumn_prefix = '[]'

" Git-gutter doesn't override default background color
highlight clear SignColumn

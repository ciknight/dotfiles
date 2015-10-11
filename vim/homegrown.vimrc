call plug#begin('~/.vim/homegrown-plugs')

" essentials
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'rking/ag.vim'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/syntastic', { 'for': ['javascript','python'] }
Plug 'SirVer/ultisnips'
Plug 'simnalamburt/vim-mundo'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'python-rope/ropevim'
Plug 'Valloric/YouCompleteMe', { 'do': './install.sh --clang-completer' }
Plug 'SirVer/ultisnips'
Plug 'ervandew/supertab'
Plug 'janko-m/vim-test'

" language-specific

" colors
Plug 'junegunn/seoul256.vim'
Plug 'stockninja/tomorrow-theme', {'rtp': 'vim' }
Plug 'andrwb/vim-lapis256'
"Plug 'luochen1990/rainbow'
"Plug 'vim-scripts/vydark'
"Plug 'vim-scripts/xoria256.vim'
"Plug 'erezsh/erezvim'                   " this spits up an error on startup
"Plug 'gregsexton/muon'
"Plug 'vim-scripts/256-grayvim'
"Plug 'mhumeSF/one-dark.vim'
"Plug 'fent/vim-frozen'
"Plug 'kristijanhusak/vim-hybrid-material'
"Plug 'orthecreedence/void.vim'
" Plug 'chriskempson/base16-vim'
" Plug 'altercation/vim-colors-solarized'

" maybe later
"Plug 'bling/vim-airline'

call plug#end()

colorscheme lapis256

syntax enable

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

" Buffer Navigation
nnoremap <silent> <F2> :bprevious<CR>
nnoremap <silent> <F3> :bnext<CR>

" }}}

" Editing {{{

" move to beginning/end of line
"nnoremap B ^
"nnoremap E $

" $/^ doesn't do anything
"nnoremap $ <nop>
"nnoremap ^ <nop>

" highlight last inserted text
nnoremap gV `[v`]

let mapleader = ','
let maplocalleader = '\\'

" allow quit/save via single keypress
noremap <leader>q :q<CR>
noremap <leader>w :w<CR>
inoremap jj <ESC>

" vimrc editing shortcuts
nnoremap <leader>eg <C-w><C-s><C-l>:e ~/.gitconfig<CR>
nnoremap <leader>ev <C-w><C-s><C-l>:e $MYVIMRC<CR>
nnoremap <leader>er <C-w><C-s><C-l>:e ~/dotfiles/vim/README.md<CR>
nnoremap <leader>sv :source $MYVIMRC<cr>


" thanks vi
nnoremap Y y$

" Inserting empty lines
nnoremap <Enter> o<ESC>
nnoremap <S-Enter> O<ESC>

" See open buffers
nnoremap <leader><leader> :buffers<CR>

" }}}

" Plugins {{{

" toggle gundo
nnoremap <leader>u :GundoToggle<CR>
" enable persistent undo so that undo history persists across vim sessions
set undofile
set undodir=~/.vim/undo

nnoremap <leader>a :Ag 
nnoremap <space> :FZF<CR>

" recommended fzf settings
set rtp+=~/.fzf

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
let NERDTreeIgnore=['\.pyc$', '\.DS_Store$', '__pycache__'] 

"" Ultisnips
let g:UltiSnipsUsePythonVersion=3
nnoremap <leader>es :UltiSnipsEdit<cr>

" make YCM compatible with UltiSnips (using supertab)
let g:SuperTabDefaultCompletionType = '<C-n>'
let g:ycm_autoclose_preview_window_after_completion=1
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" Fugitive
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gd :Gdiff<cr>

" Syntastic
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_javascript_checkers=['eslint', 'jshint']
autocmd FileType javascript let b:syntastic_checkers=findfile('.eslintrc', '.;') !=# '' ? ['eslint'] : []

function! ToggleSyntasticErrors()
    let old_last_winnr = winnr('$')
    lclose
    if old_last_winnr == winnr('$')
        " Nothing was closed, open syntastic error location panel
        Errors
    endif
endfunction

" toggle syntastic error list
nnoremap <silent> <C-e> :<C-u>call ToggleSyntasticErrors()<CR>

" Airline - currently disabled
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1     " show buffer numbers
let g:airline#extensions#tabline#fnamemod = ':t'        " Just show the filename (no path) in the tab
let g:airline_theme = 'base16'
let g:airline_powerline_fonts = 1

" }}}
 
" Functions {{{

" toggle between number and relativenumber
function! ToggleNumber()
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunc

" Better Help Windows
function! OpenHelpInCurrentWindow(topic)
  view $VIMRUNTIME/doc/help.txt
  setl filetype=help
  setl buftype=help
  setl nomodifiable
  exe 'keepjumps help ' . a:topic
endfunction

command! -nargs=? -complete=help Help call OpenHelpInCurrentWindow(<q-args>)
nnoremap <silent> <leader>h :Help 

" Delete inactive buffers
function! DeleteInactiveBufs()
    "From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor

    "Below originally inspired by Hara Krishna Dara and Keith Roberts
    "http://tech.groups.yahoo.com/group/vim/message/56425
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
        "bufno exists AND isn't modified AND isn't in the list of buffers open in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
nnoremap <leader>tb :call DeleteInactiveBufs()<cr>

" }}}

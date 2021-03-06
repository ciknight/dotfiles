"""""""""""
" Plugins "
"""""""""""

call plug#begin('~/.config/nvim/plugs')

" Source Control
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Navigation
Plug 'MattesGroeger/vim-bookmarks'
Plug 'szw/vim-tags'
Plug 'szw/vim-maximizer'

" Editing
Plug 'scrooloose/nerdcommenter'

" Colors
Plug 'chriskempson/base16-vim'

" Languages
" Plug 'klen/python-mode'
" Plug 'OmniSharp/omnisharp-vim'
Plug 'tpope/vim-dispatch'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
" Plug 'rust-lang/rust.vim'

" Other
Plug 'Shougo/denite.nvim'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'tpope/vim-obsession'
" Plug 'vim-syntastic/syntastic'
Plug 'neomake/neomake'

call plug#end()

"""""""""""""""""
" Configuration "
"""""""""""""""""

" Vanilla
set number
set expandtab

set list
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

colorscheme base16-eighties
let base16colorspace=256  " for ^^

" FIXME: Hack for alacritty: https://github.com/jwilm/alacritty/issues/26
if has("termguicolors")
  set termguicolors
endif

" Plugins
let g:NERDSpaceDelims = 1

" let g:syntastic_vim_checkers = ['vint']
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*

" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

let g:neomake_javascript_enabled_makers = ['standard']
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_python3_enabled_makers = ['flake8']
let g:qf_loclist_window_bottom=0

" Use local standard executable
let g:neomake_javascript_standard_exe = $PWD .'/node_modules/.bin/standard'
let g:neomake_python_flake8_exe = $PWD .'/venv/bin/flake8'
let g:neomake_python3_flake8_exe = $PWD .'/venv/bin/flake8'

autocmd! BufWritePost,BufEnter * Neomake

if filereadable('~/.nvim_python/bin/activate')
  source ~/.nvim_python/bin/activate
endif

" Change mappings.
" FIXME: I added this b/c I couldn't 
call denite#custom#map(
      \ 'insert',
      \ '<C-j>',
      \ '<denite:move_to_next_line>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'insert',
      \ '<C-k>',
      \ '<denite:move_to_previous_line>',
      \ 'noremap'
      \)

" Ag command on grep source
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts',
		\ ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" let g:OmniSharp_selector_ui = 'denite'

source ~/dotfiles/nvim/status.vim

" Bookmarks
highlight BookmarkSign ctermbg=NONE ctermfg=160
highlight BookmarkLine ctermbg=194 ctermfg=NONE
let g:bookmark_sign = '>>'
let g:bookmark_annotation_sign = '##'
let g:bookmark_highlight_lines = 1

" JS
let g:jsx_ext_required = 0


autocmd Filetype javascript setlocal ts=2 sts=2 sw=2

" Pylint configuration file
let g:pymode_lint_config = '$HOME/pylint.rc'

""""""""""""
" Mappings "
""""""""""""

" Personal
inoremap jj <ESC>

" Leaders
let mapleader = ' '
let maplocalleader = ','

" Windows
nmap <leader>w= <C-W>=
nmap <leader>wh <C-W>h
nmap <leader>wj <C-W>j
nmap <leader>wk <C-W>k
nmap <leader>wl <C-W>l
nmap <leader>ws <C-W>s
nmap <leader>wv <C-W>v
nmap <leader>wd :q<CR>
nmap <leader>wm :MaximizerToggle<CR>

" File
map <leader>ff :e <C-R>=expand("%:p:h") . "/" <CR>
nmap <leader>fs :w<CR>

" Dotfiles
nmap <leader>dez :e ~/.zshrc<CR>
nmap <leader>drz :echo 'todo'<CR>
nmap <leader>det :e ~/.tmux.conf<CR>
nmap <leader>drt :echo 'todo'<CR>
nmap <leader>dev :e ~/.config/nvim/init.vim<CR>
nmap <leader>drv :source ~/.config/nvim/init.vim<CR>

" Buffers
nmap <leader>bb :buffers<CR>
nmap <leader>bl :b#<CR>

" On/Off
nmap <leader>qq :qa<CR>

" Commenting
" TODO: How should I document NerdCommenter keybindings?
" It's nice for this to be like documentation for every feature I use

" Package Management
nmap <leader>pi :PlugInstall<CR>
nmap <leader>pc :PlugClean<CR>
nmap <leader>pu :PlugUpdate<CR>

" Denite
nnoremap <leader>/ :Denite grep<cr>
nnoremap <leader>ff :Denite file_rec<cr>
map <leader>fe :e <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <leader><leader> :

" Tags
" TODO: tj
nmap <leader>tt :TagbarToggle<CR>
nmap <leader>tg :TagbarGenerate<CR>

" Bookmarks
nmap <leader>mt <plug>BookmarkToggle<cr>
nmap <leader>mi <plug>BookmarkAnnotate 
nmap <leader>ma <plug>BookmarkShowAll<cr>
nmap <leader>mn <plug>BookmarkNext<cr>
nmap <leader>mp <plug>BookmarkPrev<cr>
nmap <leader>mc <plug>BookmarkClear<cr>
nmap <leader>mx <plug>BookmarkClearAll<cr>
nmap <leader>mk <plug>BookmarkMoveUp<cr>
nmap <leader>mj <plug>BookmarkMoveDown<cr>
nmap <leader>mfs <plug>BookmarkSave 
nmap <leader>mfl <plug>BookmarkLoad 

" Git
nmap <leader>gs :Gstatus<cr>


" Random Ergonomics
inoremap jj <ESC>

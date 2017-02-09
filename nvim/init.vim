"""""""""""
" Plugins "
"""""""""""
call plug#begin('~/.config/nvim/plugs')
Plug 'szw/vim-maximizer'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/vimproc.vim', {'do': 'make'}
Plug 'klen/python-mode'
Plug 'scrooloose/nerdcommenter'
Plug 'chriskempson/base16-vim'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-obsession'
call plug#end()

"""""""""""""""""
" Configuration "
"""""""""""""""""

" Vanilla
colorscheme base16-eighties
let base16colorspace=256  " for ^^

" FIXME: Hack for alacritty: https://github.com/jwilm/alacritty/issues/26
if has("termguicolors")
  set termguicolors
endif

" Plugins
let g:NERDSpaceDelims = 1

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
nmap <leader>dze :e ~/.zshrc<CR>
nmap <leader>dvr :echo 'todo'<CR>
nmap <leader>dpe :e ~/.zshenv<CR>
nmap <leader>dpr :echo 'todo'<CR>
nmap <leader>dte :e ~/.tmux.conf<CR>
nmap <leader>dtr :echo 'todo'<CR>
nmap <leader>dve :e ~/.config/nvim/init.vim<CR>
nmap <leader>dvr :source ~/.config/nvim/init.vim<CR>

" Buffers
nmap <leader>bb :buffers<CR>

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

" Random Ergonomics
inoremap jj <ESC>

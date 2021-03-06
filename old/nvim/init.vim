" Plugins
call plug#begin('~/.config/nvim/plugs')
Plug 'szw/vim-maximizer'
Plug 'klen/python-mode'
call plug#end()

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
nmap <leader>fs :w<CR>
nmap <leader>fed :e ~/dotfile/init.vim<CR>
nmap <leader>feR :source ~/.config/nvim/init.vim<CR>

" Buffers
nmap <leader>bb :buffers<CR>

" On/Off
nmap <leader>qq :qa<CR>

" Random Ergonomics
inoremap jj <ESC>

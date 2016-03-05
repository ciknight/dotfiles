" Neoplete
let g:deoplete#enable_at_startup = 1

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
let NERDTreeIgnore=['\.pyc$', '\.DS_Store$', '__pycache__'] 

" FZF
set rtp+=~/.fzf
nnoremap <space> :FZF<CR>

" Ag
nnoremap <leader>a :Ag 

" GitGutter
nnoremap <leader>tg :GitGutterToggle<CR>

" Fugitive
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gd :Gdiff<cr>

" Neomake
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_python_enabled_makers = ['flake8']
let g:neomake_open_list = 0

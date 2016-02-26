" Neoplete
let g:deoplete#enable_at_startup = 1

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>f :NERDTreeFind<CR>
let NERDTreeIgnore=['\.pyc$', '\.DS_Store$', '__pycache__'] 

" FZF
set rtp+=~/.fzf
nnoremap <space> :FZF<CR>

" GitGutter
nnoremap <leader>tg :GitGutterToggle<CR>

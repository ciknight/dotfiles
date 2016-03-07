call plug#begin('~/.config/nvim/plugs')

" General
Plug 'tpope/vim-sensible'

" Automation
Plug 'benekastah/neomake'
Plug 'Shougo/deoplete.nvim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' }
Plug 'junegunn/fzf.vim'

" Editing
Plug 'tpope/vim-surround'
Plug 'editorconfig/editorconfig-vim'
Plug 'scrooloose/nerdcommenter'

" Navigation
Plug 'scrooloose/nerdtree'
Plug 'christoomey/vim-tmux-navigator'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Miscellaneous
Plug 'vim-utils/vim-man'

" Python
"Plug 'davidhalter/jedi-vim'
Plug 'zchee/deoplete-jedi'

" Javascript
"Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }

" Colors
Plug 'altercation/vim-colors-solarized'
Plug 'hukl/Smyck-Color-Scheme'

call plug#end()

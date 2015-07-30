My Vim Setup
============

Installation:

    git clone git://github.com/stockninja/my-vim-setup ~/.vim

Run `brew install cmake` and `./install.sh` from within the `dotfile/vim/plugs/YouCompleteMe` directory

Run `npm install` from within the `vim/bundle/tern` directory.

Inspired by [this](http://www.sontek.net/blog/2011/05/07/turning_vim_into_a_modern_python_ide.html) and [this](http://unlogic.co.uk/2013/02/08/vim-as-a-python-ide/) and [&#9731;](https://github.com/UnicodeSnowman/cap-vim) among others.

Install "Droid Sans Mono for Powerline" font from [here](https://github.com/powerline/fonts) using osx's "Font Book" app


Notes
=====

Navigation
----
* `<C-d>` scroll down 1 page
* `<C-u>` scroll up 1 page
* `gj` and `gk` navigate "display lines" — which are the result of `:set wrap`
* `H` move to top of screen
* `M` move to middle of screen
* `L` move to bottom of screen
* `?abc` searches backwards for "abc" string

z
=
* zi	switch folding on or off
* za	toggle current fold open/closed
* zc	close current fold
* zR	open all folds
* zM	close all folds
* zv	expand folds to reveal cursor
* `z.` current line to middle of screen
* `zt` current line to top of screen
* `zb` current line to bottom of screen


Editing
-------
* `vd/ge<CR>` deletes everything before the first occurrence of "ge" (an "exclusive" motion)
* In visual modes:
    * `i]` expands selection inside next "]".
    * `a]` expands selection around next "]".
* `%` jumps to matching ({[ etc
* `<c-r>#` pastes from register # (insert mode)
* `gp/P` paste with different cursor position
Python
------
 `<C-Space>` Completion
* `<leader>g` Goto assignments
* `<leader>d` Goto definitions
* `K` Show Documentation/Pydoc
* `leader>r` Renaming
* `<leader>n` Usages
* `:Pyimport os` Open module (opens the os module)
* `<leader>pw` reads the docs for a function. (supertab ... necesary?)

[[                Jump to previous class or function (normal, visual, operator modes)
]]                Jump to next class or function  (normal, visual, operator modes)
[M                Jump to previous class or method (normal, visual, operator modes)
]M                Jump to next class or method (normal, visual, operator modes)
aC                Select a class. Ex: vaC, daC, yaC, caC (normal, operator modes)
iC                Select inner class. Ex: viC, diC, yiC, ciC (normal, operator modes)
aM                Select a function or method. Ex: vaM, daM, yaM, caM (normal, operator modes)
iM                Select inner function or method. Ex: viM, diM, yiM, ciM (normal, operator modes)

Search
------
* `<leader>t` does fuzzy text search in whole project
* `<leader>b` does fuzzy text search on open buffers
* `<leader>a` triggers Ack search on word under cursor

Buffers
-------
* I'm using [minibufexpl](https://github.com/techlivezheng/vim-plugin-minibufexpl) to better manage buffers
* `:e foo.py` to open file foo.py in a buffer
* `:b1` to switches to first buffer
* `:bd` or `:bw` close buffers

Window Sizing
-------------
* `Ctrl+w + v` Vertical Split
* `Ctrl+w + s` Horizontal Split
* `Ctrl+w + q` Close current windows
* `<C-w>=` Equalize width and height of all windows (except NERDTree explorer!)

Status Bar
----------
* Vim-status only works in split screen ... [Fix later](https://github.com/bling/vim-airline/wiki/FAQ)

Plugins
=======

Minibufexpl
-----------
* `<c-direction>` switch buffer

Jedi-vim
--------
* **python refactoring**

Python-Mode
-----------
* `<leader>r` run python code
* `<leader>b` add/remove breakpoints
* `<C-c>g` jumps to definition

Nerd Tree
---------
* `<leader>n` opens Nerd Tree file browser
* `m` open menu (new node, delete node, move node, copy node)
* `r` reload
* `o` Open files, directories and bookmarks
* `<shift>i` shows dotfiles
* go            Open selected file, but leave cursor in the NERDTree
* t              Open selected node/bookmark in a new tab
* T              Same as 't' but keep the focus on the current tab
* i              Open selected file in a split window
* gi            Same as i, but leave the cursor on the NERDTree
* s              Open selected file in a new vsplit
* gs            Same as s, but leave the cursor on the NERDTree
* O              Recursively open the selected directory
* x              Close the current nodes parent
* X              Recursively close all children of the current node
* e              Edit the current dir

Surround
========
* block select + `S{` to wrap block in curlies

Ctrlp
=====
* with ctrlp open, hit <F5> to update the cache (so new files show up)


General
=======
* `,bq` closes buffer
* `,m` toggles relative vs absolute line numbers
* `,ev` edit vimrc in a split tab
* `*` highlights all occurence of word.
* `g~` shifts case
* `di"` deletes inside pair of quotes
* `:UltiSnipsEdit` allows you to edit snippets for language you're currently editing
* `<C-w HJKL>` swaps windows
* `viw` block selects word where cursor lives
* `zz` center the cursor, `zb` and `zt` bring to bottom and top of page
* `,th` to toggle search highlighting

Neovim
======
* install neovim plugin

TODO:
=====
* autopep8 shouldn't change absolute imports to relative imports
* figure out how to use ipdb in python-mode
* customize git-gutter colors
* change "$PLUG_HOME"
* I'm ignoring ALL "line too long errors" in pymode ... somehow failling to do the custom pymode config
* Figure out ideavimrc?
* `,gs` and ":Gstatus" isn't visible until typing starts
* pymode
    * I remapped `K` to do what `<C-c>d` did -- "pymode_rope_show_doc_bind"  ... jank
* make a "layman's" mode, where ; and <esc> aren't strangely remapped
* should be able to version-control dotfiles from another project (using Fugitive?)
* nested folding in my vimrc?

Random Intended Exploration:
============================
- how do you have stuff (search results, etc) highlighted?
- ; and , are used with f/F/t/T
- "interesting word" highlight
- kana/vim-object-*
- vim-peekaboo      registers
- marks are dope: ma to mark, 'a to return
- let g: centeronsearch = 'zvzz'
- vimundo -- run undo on previous saves
- how do i put them in a different place?
- vimcasts bubbling text
- slime
- ^ goes to beginning of line
- leader arrow is to resize by 3
- vim-markology
- vim-wiki checklist

Notes
=====

Python
------

* `<C-Space>` Completion
* `<leader>g` Goto assignments
* `<leader>d` Goto definitions
* `K` Show Documentation/Pydoc
* `<leader>r` Renaming
* `<leader>n` Usages
* `:Pyimport os` Open module (opens the os module)
* `<leader>pw` reads the docs for a function. (supertab ... necesary?)

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

Browsing
--------
* `<leader>n` opens Nerd Tree file browser

Status Bar
----------
* Vim-status only works in split screen ... [Fix later](https://github.com/bling/vim-airline/wiki/FAQ)

# Plugins

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
*

Nerd Tree
---------
* `NERDTreeToggle` toggles the tree
* o              Open files, directories and bookmarks
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


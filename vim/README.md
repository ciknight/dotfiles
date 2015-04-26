My Vim Setup
============

Installation:

    git clone git://github.com/stockninja/my-vim-setup ~/.vim

Create symlinks:

    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/ideavimrc ~/.ideavimrc    

Switch to the `~/.vim` directory, and fetch submodules:

    cd ~/.vim
    git submodule init
    git submodule update
    
To add additional submodules to repo, run:

    git submodule add http://github.com/[user]/[repo-name].git bundle/[repo-name-of-choice]

Inspired by [this](http://www.sontek.net/blog/2011/05/07/turning_vim_into_a_modern_python_ide.html) and [this](http://unlogic.co.uk/2013/02/08/vim-as-a-python-ide/) and [&#9731;](https://github.com/UnicodeSnowman/cap-vim) among others.

Notes
=====

Navigation
-----
* `<C-d>` scroll down 1 page
* `<C-u>` scroll up 1 page

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

Nerd Tree
---------
* `<leader>n` opens Nerd Tree file browser
* `m` open menu (new node, delete node, move node, copy node)
* `r` reload
* `o` Open files, directories and bookmarks
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


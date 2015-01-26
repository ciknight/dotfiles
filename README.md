My Vim Setup
-----------

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

Inspired by [this](http://www.sontek.net/blog/2011/05/07/turning_vim_into_a_modern_python_ide.html) and [this](http://unlogic.co.uk/2013/02/08/vim-as-a-python-ide/) and [UnicodeSnowman](https://github.com/UnicodeSnowman/cap-vim) among others.

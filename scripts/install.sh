#! /bin/sh
SYSTEM=`uname -s`

if [ $SYSTEM == "Darwin" ]; then
    # Need disable command + q, modify osx keyboard shortcuts
    if hash brew 2> /dev/null; then
        echo 'Already install homebrew'
    else
        echo 'Install homebrew...'
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        # arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    # Install tools
    ## ack, ag, pt or rg, support vim ctrlsf and tagbar
    brew install ack the_silver_searcher ctags
    brew install htop lazygit ipcalc cloc tig jq wget ncdu zoxide
    ## Install neovim tmux
    brew install git zsh tmux neovim
    # Fix tmux exited on osx
    brew install reattach-to-user-namespace

    # Install languages
    # python dependency
    brew install openssl@1.1 readline sqlite3 xz zlib bzip2 libffi pkg-config
    brew install golang
    curl -sL install-node.now.sh/lts | bash
    curl -o- -L https://yarnpkg.com/install.sh | bash

    # https://tclementdev.com/timemachineeditor/
    # brew install --cask timemachineeditor
    # brew install --cask mounty
    # brew install --cask java or download java sdk.

    # install powerline fonts, set terminal font support powerline
    # git clone https://github.com/powerline/fonts.git ~/.fonts
    # wget https://gist.github.com/baopham/1838072/raw/616d338cea8b9dcc3a5b17c12fe3070df1b738c0/Monaco%2520for%2520Powerline.otf
    # sh ~/.fonts/install.sh

    # https://github.com/ryanoasis/nerd-fonts
    # curl -L https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/install.sh | bash

    # iterm Gruvbox Dark
    # https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Gruvbox%20Dark.itermcolors
    fi
elif [ $SYSTEM = "Linux" ]; then
    echo 'Updating apt and install software'
    if which apt 2>&1 > /dev/null; then
        sudo apt update -y
        sudo apt install -y gcc cmake curl tig lynx htop exuberant-ctags silversearcher-ag jq ack-grep
        sudo apt install -y git zsh tmux vim neovim

        # zoxide: z 目录跳转；老版本 apt 源没有时回退官方安装脚本
        if apt-cache show zoxide >/dev/null 2>&1; then
            sudo apt install -y zoxide
        else
            curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sudo sh -s -- --bin-dir /usr/local/bin
        fi

        sudo apt install -y golang npm
    elif which yum 2>&1 > /dev/null; then
        # yum -y install epel-release
        # yum -y install https://centos7.iuscommunity.org/ius-release.rpm  # CentOS 7,
        yum update
        yum install openssl-devel readline-devel sqlite-devel
        yum install bzip2-devel libffi-devel
        yum install -y git htop vim zsh tmux neovim
        yum install -y cmake jq ack-grep the_silver_searcher fd-find ctags curl tig
        yum install -y gcc gcc-c++ golang npm
        curl -sL install-node.now.sh/lts | bash
        curl -o- -L https://yarnpkg.com/install.sh | bash
        # cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    else
        echo 'Unsupport Linux System'
        exit 0
    fi
else
    echo 'Unsupport System!'
    exit 0
fi


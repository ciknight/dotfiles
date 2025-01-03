#! /bin/sh

install_python () {
    #### Install pyenv and python3
    if hash pyenv 2>/dev/null; then
        echo 'Already install pyenv'
    else
        if [ -d ~/.pyenv ] ; then
            timestamp=$(date +%Y%m%d%H%M%S)
            mv ~/.pyenv ~/.pyenv.old.$timestamp
        fi

        # pyenv, https://github.com/pyenv/pyenv-installer.git
        curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

        # enable pyenv
        export PYENV_ROOT="$HOME/.pyenv"
        [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
        export PYTHON_BUILD_MIRROR_URL="https://pyenv.ibeats.top"
        eval "$(pyenv init -)"
        eval "$(pyenv init --path)"
        # install plugin pyenv-alias
        #git clone https://github.com/s1341/pyenv-alias.git $(pyenv root)/plugins/pyenv-alias
        # install python3, install tk dependency
        sudo apt-get install -y libbz2-dev libncurses5-dev libxcursor1 libffi-dev libreadline-dev libsqlite3-dev liblzma-dev tk-dev libx11-dev libxss1 libxrandr2 libxrender1 libxi6 libxtst6
        pyenv install 3.11.10
        pyenv global 3.11.10
    fi

    pyenv global 3.11.10

    #### Install pip
    PYTHON=`which python`
    # python -m ensurepip --upgrade
    wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py && $PYTHON /tmp/get-pip.py
    # python util
    pip install virtualenv pipenv ipython
    echo "Install python done"
}

install_python;

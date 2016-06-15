export EDITOR=/usr/local/bin/nvim
export VISUAL=/usr/local/bin/nvim

#export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/deployd/bin:/usr/local/MacGPG2/bin:/usr/local/sbin:/Users/Justin/bin:/Users/Justin/Library/Android/sdk/platform-tools:/Applications/Racketv6.2/bin:/Users/Justin/bin/didit-cli-client:/Users/justin/bin/neo4j-community-2.2.3/bin:/Users/justin/.rvm/"

PATH=$PATH:/usr/local/bin

export ZSH=$HOME/.oh-my-zsh
export ANDROID_HOME=/usr/local/opt/android-sdk
export PYENV_ROOT=~/.pyenv

# less syntax highlighting
LESSPIPE=`which src-hilite-lesspipe.sh`
export LESSOPEN="| ${LESSPIPE} %s"
export LESS='-R'

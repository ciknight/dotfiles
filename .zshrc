# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="af-magic"  # must be before source oh-my-zsh.sh
export SYSTEM=`uname -s`
# Add wisely, as too many plugins slow down shell startup.
if [ $SYSTEM = "Darwin" ] ; then
    plugins=(git brew)
elif [ $SYSTEM = "Linux" ] ; then
    plugins=(git systemd)
fi

source $ZSH/oh-my-zsh.sh

if [ $SYSTEM = "Darwin" ] ; then
    # brew cdn
    export HOMEBREW_BOTTLE_DOMAIN=http://7xkcej.dl1.z0.glb.clouddn.com
    # JAVA_HOME
    export JAVA_HOME=$(/usr/libexec/java_home)
    export PATH=$PATH:$JAVA_HOME/bin
elif [ $SYSTEM = "Linux" ] ; then
    # None
fi

# Path
export PATH="$HOME/bin:$PATH";
export GOPATH="$HOME/workspace/go"  # Golang Path
export SSH_KEY_PATH="~/.ssh/id_rsa"

# Lang
export PYTHONIOENCODING=UTF-8  # Fix python shell failed to write data to stream
export LANG=zh_CN.UTF-8  # You may need to manually set your language environment
export LC_ALL=zh_CN.UTF-8  # Fix pipenv LC
export LESSCHARSET=utf-8  # Fix linux git diff and log chinese

# Pyenv
export PYTHON_BUILD_MIRROR_URL="http://pyenv.qiniudn.com/pythons"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# Fix neo vim mypy flake8 yapf bin path
export PATH=$PATH:~/workspace/neovim3/bin

# Pipenv
export PIPENV_PYPI_MIRROR="https://pypi.tuna.tsinghua.edu.cn/simple"
export PYPI_MIRROR=$PIPENV_PYPI_MIRROR
eval "$(pipenv --completion)"

# Fzf
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="--height 40% --reverse --border --prompt '>>>' \
    --bind 'alt-j:preview-down,alt-k:preview-up,ctrl-v:execute(nvim {})+abort,ctrl-y:execute-silent(cat {} | pbcopy)+abort,?:toggle-preview' \
    --header 'A-j/k: preview down/up, C-v: open in vim, C-y: copy, ?: toggle preview' \
    --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null'"

# History
export HISTFILE=~/.zsh_histfile     # Where to save history.
export HISTSIZE=1000000             # How many lines in the current session to remember.
export SAVEHIST=1000000             # How many lines to save to disk. Must be <=HISTSIZE.
# Patterns to exclue. Separate with |. *-matching.
export HISTORY_IGNORE="poweroff|reboot|halt|shutdown|xlogout|exit|who"

# System alias
if which nvim 2>&1 > /dev/null; then
  alias vi=nvim
elif which vim 2>&1 > /dev/null; then
  alias vi=vim
else
  alias vi=vi
fi
alias ssh='ssh -2'
alias df='df -h'
alias du='du -h -d 1' # Path Deep
alias last='last -n 10'
alias now='date +"%Y-%m-%d %T"'
alias pg='ps -ef | grep'
alias ports='netstat -tulanp'
alias pong='ping -c 5 ' # Ping limited
alias tailf='tail -f'

# Git alias
alias gdc='git diff --cached'

# Soft alias
alias tn='tmux -2 new -s'
alias ta='tmux -2 attach -t' # -2 Force tmux to assume the terminal supports 256 colours.
alias rm=safe_rm
alias cp=smart_cp
alias weather='curl wttr.in/~上海'
alias myip='curl myip.ipip.net' # 'http://ipecho.net/plain;echo'
alias rmpyc='find . -name "*.pyc" -exec rm -rf {} \; >> /dev/null 2>&1'  # 递归删除目录下所有pyc
alias resdns='dscacheutil -flushcache'
alias netlisten='lsof -i -P | grep -i "listen"'
alias seed='vim /tmp/`timestamp`.md'
alias mobi-agent='ssh-add ~/.ssh/mobi_rsa' # ssh-agent zsh
alias cvenv='virtualenv -p `which python3` venv; source venv/bin/activate'
alias avenv='source venv/bin/activate'
alias piprun='pipenv run python'
alias fz='vi $(fzf)'

# Toggle vim, usage ^z
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Load Z jump around
. $HOME/.z.sh

# Load local zshrc
zshrc_local=~/.zshrc_local
if [ -f $zshrc_local ]; then
    source $zshrc_local
fi

alias gx="git diff | gitx"
alias gsx="git diff --staged | gitx"
alias gox="git diff origin/master | gitx"

alias backend="cd ~/karmic/karmicapp/src && workon karmic && clear"
alias mobile="cd ~/karmic/mobile-app && nvm use 5.5.0 && clear"

alias pg-stop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias pg-start="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"

alias adbr="adb -e shell input keyevent 82"

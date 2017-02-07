# This is in the tmate example ... not sure why
# Docker said this was only necessary for older ubuntu versions ...
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo add-apt-repository ppa:tmate.io/archive
sudo apt-get update
sudo apt-get install -y git tmux mosh neovim python-dev python-pip python3-dev python3-pip docker-engine zsh

# Install oh-my-zsh
curl -L http://install.ohmyz.sh | sh

chsh -s $(which zsh)

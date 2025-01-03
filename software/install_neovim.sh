#! /bin/sh

wget https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod +x ./nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

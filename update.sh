#! /usr/bin/env zsh

# Update emacs
cd ~/.emacs.d
/opt/cask/bin/cask update

# Update node modules
cd ~/dots/node

echo "Updating NPM"
sudo npm i -g npm

echo "Upgrading node modules"
sudo npm i -g
sudo npm up -g

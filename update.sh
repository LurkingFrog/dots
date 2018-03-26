#! /usr/bin/env zsh

# Update emacs (Primarily using VSCode so no need for this)
# cd ~/.emacs.d
# /opt/cask/bin/cask update

# Update node modules
export NODE_PATH=/usr/lib/nodejs:/usr/lib/node_modules:/usr/share/javascript
cd ~/dots/node

echo -e "\nUpdating NPM"
sudo npm i -g npm

echo -e "\nUpgrading node modules"
sudo npm i -g
sudo npm up -g


echo -e "\nUpdating Rust"
rustup update
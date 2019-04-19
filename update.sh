#! /usr/bin/env zsh

echo -e "\n\nUpdating installed modules --"

# Update emacs (Primarily using VSCode so no need for this)
# cd ~/.emacs.d
# /opt/cask/bin/cask update

# Update node modules
# export NODE_PATH=/usr/lib/nodejs:/usr/lib/node_modules:/usr/share/javascript
echo -e "\n\tUpdating NPM\n"
cd ~/dots/node
nvm install --latest-npm

echo -e "\nUpgrading node modules"
ncu -u -l info
npm i -d
npm up -d


echo -e "\n\tUpdating Rust"
rustup update
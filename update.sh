#! /usr/bin/env zsh

echo -e "\n\nUpdating installed modules --"

# Update emacs (Primarily using VSCode so no need for this)
# cd ~/.emacs.d
# /opt/cask/bin/cask update

# Update node modules
# export NODE_PATH=/usr/lib/nodejs:/usr/lib/node_modules:/usr/share/javascript
echo -e "\n\tUpdating NVM/NPM\n"

# Start up NVM
NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" # This loads nvm

# Global - for some reason this is different than the local one I install packages from
nvm install --latest-npm
cd ~/dots/node
nvm alias default node

echo -e "\nUpgrading node modules"
ncu -u -l info
npm i -d
npm up -d


echo -e "\n\tUpdating Rust"
rustup update
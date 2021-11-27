#! /usr/bin/env zsh

WORKDIR=$(dirname $0:A)
source $WORKDIR/conf.sh


function update_nvm() {
    # Start up NVM
    NVM_DIR="${HOME}/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh" # This loads nvm

    local current=$(nvm -v)
    local latest=$(
        git -c 'versionsort.suffix=-' ls-remote \
            --exit-code --refs --sort='version:refname' \
            --tags https://github.com/nvm-sh/nvm.git '*.*.*' \
        | tail --lines=1 \
        | cut --delimiter='/' --fields=3 \
    )

    if [[ "$latest" != "v$current" ]]; then
        echo -e "NVM is currently $current. Upgrading to $latest"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${latest}/install.sh | bash
        [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    else
        echo -e "\t$latest is the most recent version of NVM and is already installed"
    fi
}


echo -e "\n\nUpdating installed modules --"

# Update emacs (Primarily using VSCode so no need for this)
# cd ~/.emacs.d
# /opt/cask/bin/cask update

# Update node modules
# export NODE_PATH=/usr/lib/nodejs:/usr/lib/node_modules:/usr/share/javascript
echo -e "\n\tUpdating NVM/NPM\n"
update_nvm

# Global - for some reason this is different than the local one I install packages from
nvm install --latest-npm
cd ~/dots/node
nvm alias default node

echo -e "\nUpgrading node modules"
ncu -u -l info
npm i -d
npm up -d

echo -e "\nExporting the most recent extensions of VS Code"
code-insiders --list-extensions | sort > ~/dots/vscode/extensions.lst


echo -e "\n\tUpdating Rust"
rustup update
echo -e "\n\tUpdating Cargo Packages"
for x in ${CARGO}; do
    ~/.cargo/bin/cargo install ${=x}
done
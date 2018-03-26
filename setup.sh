#! /usr/bin/env bash

# This requires my usual git key if I want to edit

# TODO: Add self to sudoers
# My DHCP doesn't seem to be supplying this line in /etc/network/interfaces
# dns-nameservers 208.67.222.222 208.67.220.220 71.250.0.12

# Fix a common develop issue - not enough watches
echo "fs.inotify.max_user_watches=524288" | sudo tee /etc/sysctl.conf
sudo sysctl -p


# Make sure the /opt directory exists and can be modified by this script
mkdir -p /opt
sudo chmod -R 777 /opt


# Get the usual installs
sudo apt-get update
sudo apt-get install -y git emacs zsh curl ruby-sass flake8 terminator sqlitebrowser
if [ ! -d ~/dots/git ]; then
    cd ~
    # Read Only
    #git clone http://github.com/lurkingfrog/dots

    # Requires ssh key, but can push edits
    git clone git@github.com:LurkingFrog/dots

else
    echo "Already cloned dots from git"
fi

# setup git
ln -s ~/dots/git/gitconfig ~/.gitconfig

# setup the shell
ln -s ~/dots/shell/screenrc ~/.screenrc

echo "Adding ZSH as default shell for $USER"
sudo usermod -s /bin/zsh $USER
ln -s ~/dots/shell/zshrc ~/.zshrc

cd ~
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
ln -s ~/dots/oh-my-zsh/frog.zsh-theme ~/.oh-my-zsh/themes/frog.zsh-theme

# Use my normal terminal config (Currently using terminator)
mkdir -p ~/.config/terminator
ln -s ~/dots/shell/terminator/config ~/.config/terminator


# Setup emacs
cd /opt
git clone https://github.com/cask/cask

mkdir -p ~/.emacs.d
cd ~/.emacs.d
ln -s ~/dots/emacs/Cask ~/.emacs.d/Cask
ln -s ~/dots/emacs/configs ~/.emacs.d/configs
ln -s ~/dots/emacs/configs/scss-lint.yml ~/.scss-lint.yml
ln -s ~/dots/emacs/init.el ~/.emacs.d/init.el


/opt/cask/bin/cask install

ln -s ~/dots/node/eslintrc ~/.eslintrc
ln -s ~/dots/node/tern-config ~/.tern-config

# Setup node (with modules for emacs' flycheck)
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt-get install -y nodejs

# The installer is broken on NPM. Instead, let's install it from git
# https://stackoverflow.com/questions/46271343/npm-install-error-cannot-find-module-read-package-json-js
#curl https://www.npmjs.com/install.sh | sudo sh
#sudo npm cache clean -f

git clone https://github.com/npm/npm.git /tmp/npm
cd /tmp/npm
sudo make install
sudo npm -d install -g ~/dots/node/
sudo n stable


# add Docker tools
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install docker-ce docker-compose
sudo usermod -aG docker $(whoami)

# Use Yarn (Javascript)
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
deb https://dl.yarnpkg.com/debian/ stable main

sudo apt-get install -y yarn

# Add in the scss linter
# sudo gem install scss_lint scss_lint_reporter_checkstyle

# add Mono
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/mono-official.list
sudo apt-get update
sudo apt-get install -y mono-devel



# VSCode setup
cd /tmp
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt-get update
sudo apt-get install -y code-insiders
while IFS='' read -r x || [[ -n "$x" ]]; do
    code-insiders --install-extension $x;
done < ~/dots/vscode/extensions.lst

mkdir ~/dots/.vscode
ln -s ~/dots/vscode/User/settings.json ~/.config/Code\ -\ Insiders/User
<<<<<<< HEAD
ln -s ~/dots/vscode/User/extensions.json ~/dots/.vscode
ln -s ~/dots/vscode/User/keybindings.json ~/.config/Code\ -\ Insiders/User
=======
ln -s ~/dots/vscode/User/keybindings.json ~/.config/Code\ -\ Insiders/User

>>>>>>> ad085904706122c05944603e9e6d5566a9fd220c

# Lets add Rust while I'm at it
curl https://sh.rustup.rs -sSf | sh -s -- -y -v --default-toolchain beta


# And Docker
sudo apt-get install -y \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

sudo apt-get update

curl -fsSL https://get.docker.com/ | sudo sh

sudo apt-get install -y docker-compose
sudo usermod -aG docker dfogelson


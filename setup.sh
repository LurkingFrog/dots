#! /usr/bin/env bash

# TODO: Add self to sudoers
# My DHCP doesn't seem to be supplying this line in /etc/network/interfaces
# dns-nameservers 208.67.222.222 208.67.220.220 71.250.0.12

# Make sure the /opt directory exists and can be modified by this script
mkdir -p /opt
sudo chmod -R 777 /opt


# Get the usual installs
sudo apt-get update
sudo apt-get install -y git emacs zsh curl


if [ ! -d ~/dots/git ]; then
    cd ~
    git clone http://github.com/lurkingfrog/dots
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


# Setup emacs
cd /opt
git clone https://github.com/cask/cask

mkdir -p ~/.emacs.d
cd ~/.emacs.d
ln -s ~/dots/emacs/Cask ~/.emacs.d/Cask
ln -s ~/dots/emacs/configs ~/.emacs.d/configs
ln -s ~/dots/emacs/init.el ~/.emacs.d/init.el

/opt/cask/bin/cask install

ln -s ~/dots/node/eslintrc ~/.eslintrc

# Setup node (with modules for emacs' flycheck)
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs

curl https://www.npmjs.com/install.sh | sudo sh
sudo npm cache clean -f
sudo npm -d install -g ~/dots/node/
sudo n stable

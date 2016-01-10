#! /usr/bin/env bash

# Get the usual installs
sudo apt-get install -y git emacs zsh curl

# setup git
ln -s ~/dots/git/gitconfig ~/.gitconfig

# setup ZSH
sudo usermod -s /bin/zsh $USER
ln -s ~/dots/zsh/zshrc ~/.zshrc

cd ~
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
ln -s ~/dots/oh-my-zsh/frog.zsh-theme ~/.oh-my-zsh/themes/frog.zsh-theme


# Setup emacs
sudo chmod -R 777 /opt
cd /opt
git clone https://github.com/cask/cask

mkdir -p ~/.emacs.d
cd ~/.emacs.d
ln -s ~/dots/emacs/Cask ~/.emacs.d/Cask
ln -s ~/dots/emacs/configs ~/.emacs.d/configs
ln -s ~/dots/emacs/init.el ~/.emacs.d/init.el

/opt/cask/bin/cask install


# Setup node (with modules for emacs' flycheck)
ln -s ~/dots/node/eslintrc ~/.eslintrc
curl https://www.npmjs.com/install.sh | sudo sh
sudo npm cache clean -f
sudo npm install -g n
sudo n stable
sudo npm install -g eslint-plugin-react eslint jsxhint tern npm-check-updates

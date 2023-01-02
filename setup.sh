#! /usr/bin/env bash

# This requires my usual git key if I want to edit

RELEASE=$(lsb_release -cs)

# Import some configuration variables
# The workdir should be your home directory
WORKDIR=$(dirname $0:A)
echo -e "Workdir: $WORKDIR"

# TODO: Add self to sudoers
# My DHCP doesn't seem to be supplying this line in /etc/network/interfaces
# dns-nameservers 208.67.222.222 208.67.220.220 71.250.0.12


# This is the only possibly interactive portion. If .ssh doesn't already exist, it needs to be pulled from
# online. The online file that contains my keys also contains the other secure certs.
function getEncryption() {
    echo -e "Download my encryption keys and put them in place"
    ./bin/syncSecure.sh
}


# Fix a common develop issue - not enough watches
echo "fs.inotify.max_user_watches=524288" | sudo tee /etc/sysctl.conf
sudo sysctl -p


# Make sure the /opt directory exists and can be modified by this script
mkdir -p /opt
sudo chmod -R 777 /opt


# Get the usual installs
sudo apt-add-repository -y multiverse
sudo apt update
sudo apt install -y \
    git emacs zsh curl flake8 terminator sqlitebrowser dolphin gcc libssl-dev openssh-server \
    direnv pkg-config unrar inotify-tools python3-pip net-tools tree m4 chromium-browser ripgrep

if [ ! -d /opt/dots/git ]; then
    cd /opt
    if [ -d ~/.ssh/id_rsa ]; then
        # Requires ssh key, but can push edits
        git clone git@github.com:LurkingFrog/dots

    else
        # Read Only
        echo -e "WARNING: Cloned dots using HTTP. Please update the upstream for editing"
        git clone http://github.com/lurkingfrog/dots
    fi;
    cd ~
    ln -s /opt/dots .
    # Import some configuration variables
else
    echo "Already cloned dots from git"
fi
source $WORKDIR/dots/conf.sh

# setup git
ln -s ~/dots/git/gitconfig ~/.gitconfig

# setup the shell
ln -s ~/dots/shell/screenrc ~/.screenrc

# setup the directory based environment switching
ln -s ~/dots/shell/envrc ~/.envrc

echo "Adding ZSH as default shell for $USER"
sudo usermod -s /bin/zsh $USER
ln -s ~/dots/shell/zshrc ~/.zshrc

cd ~
git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
ln -s ~/dots/oh-my-zsh/frog.zsh-theme ~/.oh-my-zsh/themes/frog.zsh-theme

# Link custom scripts to local
sudo mkdir -p /usr/local/bin
for x in `ls -d -1 ~/dots/bin/*`; do \
    echo  "Moving '$x' to /usr/local/bin'"; \
    chmod 755 $x; \
    sudo ln -s $x /usr/local/bin/; \
done

# Use my normal terminal config (Currently using terminator)
mkdir -p ~/.config/terminator
ln -s ~/dots/shell/terminator/config ~/.config/terminator

# And update the css used for the terminator display
mkdir -p ~/.config/gtk-3.0
ln -s ~/dots/shell/gtk-3.0/gtk.css ~/.config/gtk-3.0

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


# Setup LTR version of node using NVM (with modules for emacs' flycheck)
mkdir -p "${HOME}/.nvm"
export NVM_DIR="${HOME}/.nvm"
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install --lts

# Use Yarn (Javascript)
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
deb https://dl.yarnpkg.com/debian/ stable main

sudo apt install -y yarn


# Install the global node modules
cd ~/dots/node
npm install -D

# add Docker tools
cd /tmp
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $RELEASE stable"
sudo apt-get update
sudo apt-get install -y docker-ce

sudo usermod -aG docker $(whoami)

function install_docker_compose() {
  echo -e "\n\tFinding Docker Compose"
  COMPOSE=($(command -v docker-compose) -f $COMPOSE_FILE)
  if [ $? -ne 0 ]; then
    echo -e "\tDocker-compose not installed: Attempting to install it now";
    sudo curl \
      -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    sudo chmod 755 /usr/local/bin/docker-compose


    COMPOSE=($(command -v docker-compose) -f $COMPOSE_FILE)
    if [ $? -ne 0 ]; then
      echo -e "\tFailed to get docker-compose"
      exit $?
    fi
  fi
  echo -e "\tFinished installing docker-compose."
  echo -e "\tUsing docker-compose command $COMPOSE"
}

function install_opam() {
    # Setup Opam (OCaml package manager)
    curl -o /tmp/opam_install.sh https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh
    chmod 755 /tmp/opam_install.sh
    echo -e "\n\n" | /tmp/opam_install.sh --fresh --no-backup
    echo -e "\n\n" opam init

    # This is the version that ReasonML uses, so we set it as default before installing the other global packages
    opam switch create 4.06.1
    opam switch set 4.06.1

    # Install the OCaml Language server
    opam pin add -y ocaml-lsp-server https://github.com/ocaml/ocaml-lsp.git

    # Install the dune (project builder), merlin (), and reason (The coding language I'm using)
    opam install -y dune merlin reason
}

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
rm -f  ~/.config/Code\ -\ Insiders/User/settings.json \
   && ln -s ~/dots/vscode/User/settings.json ~/.config/Code\ -\ Insiders/User
ln -s ~/dots/vscode/User/extensions.json ~/dots/.vscode
ln -s ~/dots/vscode/User/keybindings.json ~/.config/Code\ -\ Insiders/User

# And link all the snippets
mkdir -p ~/.config/Code\ -\ Insiders/User/snippets/
for x in `ls -d -1 ~/dots/vscode/User/snippets/*json`; do \
    echo  $x;\
    ln -s $x ~/.config/Code\ -\ Insiders/User/snippets/;\
done


# Install Rust and some associated features
curl https://sh.rustup.rs -sSf | sh -s -- -y -v --default-toolchain stable
~/.cargo/bin/rustup toolchain install nightly
~/.cargo/bin/rustup component add ${RUSTUP}

# Build WASM from Rust projects
rustup target add wasm32-unknown-unknown

# Required before installing diesel_cli
sudo apt install -y libpq-dev
sudo ln -s /usr/lib/x86_64-linux-gnu/libzmq.so.5 /usr/lib/x86_64-linux-gnu/libpq.so

for item in ${CARGO}; do ~/.cargo/bin/cargo install ${=item}; done

# Make my usual formatting global for cargo
mkdir -p ~/.config/rustfmt
cd $WORKDIR/rust
ln -s $WORKDIR/rust/rustfmt.toml ~/.config/rustfmt/

# cargo +stable fmt to run rustfmt no matter the active toolchain

# This is so we can have HTTPS enabled on nginx
function setup_lets_encrypt() {
    sudo snap install core
    sudo snap refresh core
    sudo snap install --classic certbot
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
    sudo certbot --nginx

    # To add a cert:
    # sudo certbot run --nginx -n --agree-tos -m dfogelson@landfillinc.com --domains fhl.landfillinc.com
    sudo certbot renew --nginx
}

# setup nginx
function add_nginx() {
    curl -fsSL https://nginx.org/keys/nginx_signing.key \
    | gpg --dearmor \
    | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg \
    > /dev/null

    echo \
        "deb [arch=amd64 signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
         https://nginx.org/packages/ubuntu/ $RELEASE nginx" \
    | sudo tee /etc/apt/sources.list.d/nginx.list > /dev/null
    sudo apt update

    sudo mkdir -p /etc/nginx
    sudo rm -f /etc/nginx/nginx.conf
    sudo ln -s ~/dots/nginx/nginx.conf /etc/nginx/nginx.conf
    sudo chmod 744 /etc/nginx/nginx.conf

    sudo apt install -y nginx
}

# Setup an Oauth2 authenticator for nginx using vouch
# https://github.com/vouch/vouch-proxy
function start_vouch() {
    sudo mkdir -p /etc/vouch

}

install_opam
add_nginx
setup_lets_encrypt




# Add in the scss linter
# sudo gem install scss_lint scss_lint_reporter_checkstyle

# add Mono - Haven't touched this in a while, so why waste space/time with it now
# sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
# echo "deb http://download.mono-project.com/repo/ubuntu xenial main" | sudo tee /etc/apt/sources.list.d/mono-official.list
# sudo apt-get update
# sudo apt-get install -y mono-devel

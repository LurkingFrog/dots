# Set the path
PATH=/home/dfogelson/bin
PATH=$PATH:/usr/local/sbin
PATH=$PATH:/usr/local/bin
PATH=$PATH:/usr/bin
PATH=$PATH::/sbin
PATH=$PATH:/bin/bin
PATH=$PATH:$CASKPATH

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="frog"

plugins=(git ubuntu command-not-found dircycle git-extras knife taskworrior pip node npm nvm pep8 meteor grunt gradle docker docker-compose cp python pylint rsync)

source $ZSH/oh-my-zsh.sh

export EDITOR=/usr/bin/emacs

# This is just a pain so I'm aliasing it
alias pip-update="pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs pip install -U"

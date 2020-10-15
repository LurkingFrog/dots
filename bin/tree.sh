#!/usr/bin/env zsh

# Ported from https://unix.stackexchange.com/questions/291282/have-tree-hide-gitignored-files

function tree-git-ignore {
    # tree respecting gitignore

    local ignored=$(git ls-files -ci --others --directory --exclude-standard)
    if [[ $ignored == "" ]]; then
      ignored_filter=".git"
    else
      local filter=$(echo "$ignored" \
                    | egrep -v "^#.*$|^[[:space:]]*$" \
                    | sed 's~^/~~' \
                    | sed 's~/$~~' \
                    | tr "\\n" "|")
      ignored_filter=".git|${filter: : -1}"
    fi
    tree -I ${ignored_filter} "$@" $(git rev-parse --show-toplevel)
}

tree-git-ignore

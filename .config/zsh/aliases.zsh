#!/bin/zsh

function check_for_command(){ command -v $1 >/dev/null 2>&1 }

alias ..="cd .."

if check_for_command kubectl
then alias k="kubectl"
fi

if check_for_command exa
then alias ls="exa"
fi

if check_for_command bat
then alias cat='bat --paging=never --style=plain'
fi

if check_for_command nvim
then alias v='nvim'
fi

if check_for_command git
then
    alias g="git"
    complete -o default -o nospace -F _git g

    alias gp="git pull"
    alias gpush="git push"
    alias gts="git status -s"
    alias gnb="git checkout -b"

    if check_for_command fzf
    then alias gsb='git checkout $(git branch | fzf)'
    fi
fi

if check_for_command yadm
then alias y='yadm'
fi

alias o='open'

if check_for_command docker
then
    alias dcu='docker compose up'
    alias dcd='docker compose down'
    alias dcr='docker compose down && docker compose up'
fi

if check_for_command egrep
then alias list_merged="git branch --merged| egrep -v \"(^\*|master|main|dev)\""
fi

alias storybook='npm run storybook'
alias update_snaps='npm run test:dev -- -u'


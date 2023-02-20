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

if check_for_command git
then
    alias g="git"
    alias gp="git pull"
    alias gpush="git push"
    alias gts="git status -s"
    alias gnb="git checkout -b"

    if check_for_command fzf
    then alias gsb='git checkout $(git branch | fzf)'
    fi

fi

alias o='open'
alias y='yadm'
alias v='nvim'

if check_for_command egrep
then alias list_merged="git branch --merged| egrep -v \"(^\*|master|main|dev)\""
fi

alias storybook='npm run storybook'
alias update_snaps='npm run test:dev -- -u'


#!/bin/zsh
#

alias o='open'

if check_for_command git; then
    alias g="git"
fi

if check_for_command nvim; then
    alias v="nvim"
fi

if check_for_command yadm; then
    alias y="yadm"
fi

if check_for_command direnv; then
    alias dallow="direnv allow ."
fi

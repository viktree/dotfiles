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
then alias g="git"
fi

if check_for_command yadm
then alias y='yadm'
fi

if check_for_command zellij
then
    alias zj="zellij"
    alias start-ecp='zellij --session ecp --layout ~/.config/zellij/layouts/ecp.kdl'
    alias ecp='zellij attach ecp'

    alias start-hslib="zellij --session home-services-lib"
    alias hslib='zellij attach home-services-lib'
fi

if check_for_command node && check_for_command fzf && check_for_command rg
then alias npmscripts="cat package.json| jq -r '.scripts | keys[]' | fzf"
fi

alias o='open'
alias c='clear'
alias cpath='pwd | pbcopy'

if check_for_command docker
then
    alias dkill='docker ps -aq | xargs docker stop'
    alias dcu='docker compose up'
    alias dcd='docker compose down'
    alias dcr='docker compose down && docker compose up'
fi

if check_for_command egrep
then alias list_merged="git branch --merged| egrep -v \"(^\*|master|main|dev)\""
fi

alias storybook='npm run storybook'
alias update_snaps='npm run test:dev -- -u'

AGENDA="$HOME/agenda/agenda.txt"
alias journal='nvim + "$AGENDA" -c "execute \"normal! Go\<CR>$(date +"%a %b %d @ %T")\<CR>==============\<CR>What did I just work on?\<CR>\<CR>What will I work on next?\<CR>\<CR>\" | startinsert "'

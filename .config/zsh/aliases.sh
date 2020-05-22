#!/bin/sh

if check_for_command nvim
then alias vim='nvim'
fi

if is_mac
then alias ls="gls --color"
else alias ls="ls --color"
fi

alias magit='nvim -c MagitOnly'

alias truepath='pwd -P'
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"

alias serve='python3 -m SimpleHTTPServer 8000'

alias ip.address="curl http://ipecho.net/plain"
alias ip.local="ipconfig getifaddr en0"

alias ..="echo 'Moved back 1 directory:' && cdls .."
alias ...="echo 'Moved back 2 directories:' && cd ../.. | ls"

alias g='git'

alias attach='tmuxinator start $(tmuxinator list -n | tail -n +2 | fzf)'


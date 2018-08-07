#!/bin/sh

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias g=git

alias ip.address="dig +short myip.opendns.com @resolver1.opendns.com"
alias ip.local="ipconfig getifaddr en0"

alias update.npm='npm install -g; npm update'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias fuck='pkill -9'
alias cls='clear'

case "$platform" in
    "osx")
        alias update.all='sudo softwareupdate -i -a; brew update; brew upgrade; brew cleanup; npm install -g; npm update'
        alias update.mac='sudo softwareupdate -i -a'
        alias update.brew='brew update; brew upgrade; brew cleanup'
        alias icons.show="defaults write com.apple.finder CreateDesktop true"
        alias icons.hide="defaults write com.apple.finder CreateDesktop false"
        alias lock="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
        alias trash.empty="sudo rm -rfv ~/.Trash;"
        alias trash.empty_all="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash;"
        ;;
    "linux")
        alias ls='ls --color=auto'
        ;;
    "freebsd")
        alias ls='ls -G'
        ;;
    *)
        ;;
esac

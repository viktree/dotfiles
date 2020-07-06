#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias yadm="$HOME/.yadm-project/yadm"

export XDG_CONFIG_HOME="$HOME/.config"

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

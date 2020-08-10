#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$PATH:$HOME/programs/bin"

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

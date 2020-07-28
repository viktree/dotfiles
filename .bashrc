#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias yadm="$HOME/.yadm-project/yadm"
alias tmux="$HOME/programs/tmux-3.2-rc/tmux"
alias entr="$HOME/programs/entr-4.6/entr"

export XDG_CONFIG_HOME="$HOME/.config"

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

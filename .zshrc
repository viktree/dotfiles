# ---------------------------------------------------------------------------------------
# ---{ My .zshrc } ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set all Hombrew apps to correct location.
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# ---{ Theme }---------------------------------------------------------------------------

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="avit"

# ---{ Plugins }-------------------------------------------------------------------------

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git extract zsh-autosuggestions zsh-syntax-highlighting
         node npm colored-man-pages python pip)

# ---{ Auto-Complete }-------------------------------------------------------------------

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

source $ZSH/oh-my-zsh.sh
bindkey '^ ' autosuggest-accept
if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

 # User configuration
fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit

# ---{ Extending $PATH }-----------------------------------------------------------------

# sup yarn
# https://yarnpkg.com

if (( $+commands[yarn] ))
then
  export PATH="$PATH:`yarn global bin`"
fi


 # export MANPATH="/usr/local/man:$MANPATH"

# ---------------------------------------------------------------------------------------

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nvim'
else
  export EDITOR='nvim'
fi


# ---------------------------------------------------------------------------------------


# ---{ Vim Mode }------------------------------------------------------------------------

# enable vim mode on commmand line
bindkey -v

# edit command with editor
# http://stackoverflow.com/a/903973
# usage: type someshit then hit Esc+v
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# no delay entering normal mode
# https://github.com/pda/dotzsh/blob/master/keyboard.zsh#L10
# 10ms for key sequences
KEYTIMEOUT=1

# show vim status
# http://zshwiki.org/home/examples/zlewidgets
function zle-line-init zle-keymap-select {
   RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
   RPS2=$RPS1
   zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# add missing vim hotkeys
# fixes backspace deletion issues
# http://zshwiki.org/home/zle/vi-mode
bindkey -a u undo
# bindkey -a '^R' redo	# conflicts with history search hotkey
bindkey -a '^T' redo
bindkey '^?' backward-delete-char	#backspace

# ---{ Better History }------------------------------------------------------------------

# history search in vim mode
# http://zshwiki.org./home/zle/bindkeys#why_isn_t_control-r_working_anymore
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

HISTSIZE=10000
SAVEHIST=10000
cfg-history() { $EDITOR $HISTFILE ;}


# ---{ Extract Compressed Files }--------------------------------------------------------

# Extract many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)  tar -jxvf "$1"                        ;;
      *.tar.gz)   tar -zxvf "$1"                        ;;
      *.bz2)      bunzip2 "$1"                          ;;
      *.dmg)      hdiutil mount "$1"                    ;;
      *.gz)       gunzip "$1"                           ;;
      *.tar)      tar -xvf "$1"                         ;;
      *.tbz2)     tar -jxvf "$1"                        ;;
      *.tgz)      tar -zxvf "$1"                        ;;
      *.zip)      unzip "$1"                            ;;
      *.ZIP)      unzip "$1"                            ;;
      *.pax)      cat "$1" | pax -r                     ;;
      *.pax.Z)    uncompress "$1" --stdout | pax -r     ;;
      *.Z)        uncompress "$1"                       ;;
      *) echo "'$1' cannot be extracted/mounted via extract()" ;;
    esac
  else
     echo "'$1' is not a valid file to extract"
  fi
}

# ---------------------------------------------------------------------------------------

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH=$HOME/.local/bin:$PATH
export PATH=/Users/tintinux/Library/Python/3.7/bin:$PATH
#export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
export NVM_DIR="$HOME/.nvm/usr/local/opt/nvm/nvm.sh"

# ---{ Aliases }-------------------------------------------------------------------------

alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'

alias zshconfig= "nvim ~/.zshrc"
alias ohmyzsh=  "nvim ~/.oh-my-zsh"
alias nvimrc="nvim ~/.config/nvim/init.vim"
alias showicons="defaults write com.apple.finder CreateDesktop true"
alias hideicons="defaults write com.apple.finder CreateDesktop false"

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'

alias fuck='pkill -9'
alias cls='clear'

# ---------------------------------------------------------------------------------------


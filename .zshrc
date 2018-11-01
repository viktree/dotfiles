# ---------------------------------------------------------------------------------------
# ---{ My .zshrc } ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   When you start an interactive zsh, it reads ~/.zshrc. This is a good place for
#   contains things that must be done for every shell instance, such as alias and
#   function definitions, shell option settings, completion settings, prompt settings,
#   key bindings, etc.
#
# ---{ General Settings }----------------------------------------------------------------

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="avit"

# Use hyphen-insensitive completion. Case sensitive completion must be off.
# _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# ---{ Plugins }-------------------------------------------------------------------------

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-autosuggestions zsh-syntax-highlighting)
plugins+=(git)
plugins+=(node zsh-better-npm-completion)
plugins+=(python pip)

# ---{ Auto-Complete }-------------------------------------------------------------------

export CASE_SENSITIVE="true"

# Standard shell completion
source $ZSH/oh-my-zsh.sh
bindkey '^ ' autosuggest-accept
if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# User configuration
fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]
  then . '$HOME/google-cloud-sdk/completion.zsh.inc'
fi

if [ -e $HOME/google-cloud-sdk/bin/kubectl ]
  then source <(kubectl completion zsh)
fi


# iterm2 Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# FZF integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


# ---{ Better History }------------------------------------------------------------------

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

# ---{ Aliases }-------------------------------------------------------------------------

alias config='/usr/bin/git --git-dir=$HOME/.myconf/ --work-tree=$HOME'

alias reload="source ~/.zshrc"
alias n=nvim
alias g=git

alias ip.address="dig +short myip.opendns.com @resolver1.opendns.com"
alias ip.local="ipconfig getifaddr en0"

alias update.npm='npm install -g; npm update'

alias ..="echo 'Moved back 1 directory:' && cdls .."
alias ...="echo 'Moved back 2 directories:' && cd ../.. | ls"
alias ..1="echo 'Moved back 1 directory:' && cd .. | ls"
alias ..2="echo 'Moved back 2 directories:' && cd ../.. | ls"
alias ..3="echo 'Moved back 3 directories:' && cd ../../.. | ls"

alias fuck='pkill -9'
alias cls='clear'

case "$PLATFORM" in
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

# ---{ Functions }-----------------------------------------------------------------------

function mkcd() { mkdir -p $1 && cd $1 }

function cdls() { cd $1 && ls }

# stolen from @topfunky
function cdf() { cd *$1*/ }

function overview(){
  tree -aC -I '.git|node_modules|bower_components|.DS_Store' --dirsfirst "$@"
}

# Extract many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
function extract() {
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

function edit() {
  case "$1" in
    git)
      $EDITOR ~/.gitconfig
      ;;
    gitmessage)
      $EDITOR ~/.gitmessage
      ;;
    gitignore)
      $EDITOR ~/.gitignore
      ;;
    nvim)
      $EDITOR ~/.config/nvim/init.vim
      ;;
    vim)
      $EDITOR ~/.vimrc &&
      source ~/.vimrc
      ;;
    zsh)
      $EDITOR ~/.zshrc &&
      source ~/.zshrc
      ;;
    profile)
      $EDITOR ~/.zprofile &&
      source ~/.zprofile
      ;;
    *)
    "edit $1 has not been setup"
    ;;
  esac
}


if [[ "$PLATFORM" == "osx" ]] then;

  function manpdf() {
    man -t $1 | open -f -a /Applications/Preview.app
  }

  function hiddenfiles() {
    if [[ "$1" == "show" ]] then;
      defaults write com.apple.Finder AppleShowAllFiles YES;
    elif [[ "$1" == "hide" ]] then;
      defaults write com.apple.Finder AppleShowAllFiles NO;
    fi
    osascript -e 'tell application "Finder" to quit';
    sleep 0.25;
    osascript -e 'tell application "Finder" to activate';
  }

fi


# ---{ Direnv }--------------------------------------------------------------------------

# Used to allow zsh to work ok
eval "$(direnv hook zsh)"

# ---------------------------------------------------------------------------------------



# ---------------------------------------------------------------------------------------
# ---{ My .zshrc } ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   When you start an interactive zsh, it reads ~/.zshrc. This is a good place for
#   contains things that must be done for every shell instance, such as alias and
#   function definitions, shell option settings, completion settings, prompt settings,
#   key bindings, etc.
#
# ---------------------------------------------------------------------------------------
# ---{ Settings for ZPLUG }--------------------------------------------------------------

function source_if_possible(){ [[ -e $1 ]] && source $1 }

# You can customize where you put it but it's generally recommended that you put
# in $HOME/.zplug
if [[ ! -d ~/.zplug ]];then
  git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

# Let zplug manage zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Async for zsh, used by pure
zplug "mafredri/zsh-async", from:github, defer:0

zplug "lib/completion", from:oh-my-zsh
zplug "lib/git", from:oh-my-zsh
zplug "lib/history", from:oh-my-zsh
zplug "lib/key-bindings", from:oh-my-zsh

zplug "andrewferrier/fzf-z"

zplug "lukechilds/zsh-better-npm-completion", defer:2

# Syntax highlighting for commands, load last
zplug "zsh-users/zsh-syntax-highlighting", from:github, defer:3
zplug "zsh-users/zsh-autosuggestions", from:github
zplug "zsh-users/zsh-completions", from:github

# Theme!
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

# The next line enables shell command completion for gcloud.
if [ -f '$HOME/google-cloud-sdk/completion.zsh.inc' ]
  then . '$HOME/google-cloud-sdk/completion.zsh.inc'
  zplug "littleq0903/gcloud-zsh-completion", lazy:true
fi

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose
    then printf "Install? [y/N]: "
    if read -q
        then echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# Brew completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Add kubectl completions if they exist
if [ -e $HOME/google-cloud-sdk/bin/kubectl ]
  then source <(kubectl completion zsh)
fi

# iterm2 Integration
source_if_possible "${HOME}/.iterm2_shell_integration.zsh"

# FZF integration
source_if_possible ~/.fzf.zsh


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
alias gh='history | grep '

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

# Alias things quickly and worry about it later.
# https://news.ycombinator.com/item?id=9869231
function save() {
  echo "alias $1='${@:2}'" >> ~/.zshrc
  echo "made alias:";
  echo "alias $1='${@:2}'";
  source ~/.zshrc;
}


# ---{ Direnv }--------------------------------------------------------------------------

export NVM_DIR="$HOME/.nvm"
# This loads nvm
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
# This loads nvm bash_completion
[ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"

# Used to allow zsh to work ok
eval "$(direnv hook zsh)"

# ---------------------------------------------------------------------------------------


export PATH="/usr/local/opt/node@10/bin:$PATH"

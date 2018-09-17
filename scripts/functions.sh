#!/bin/sh

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
    alias)
      $EDITOR ~/scripts/aliases.sh
      source ~/scripts/aliases.sh
      ;;
    aliases)
      $EDITOR ~/scripts/aliases.sh
      source ~/scripts/aliases.sh
      ;;
    env)
      $EDITOR ~/scripts/variables.sh
      source ~/scripts/variables.sh
      ;;
    functions)
      $EDITOR ~/scripts/functions.sh
      source ~/scripts/functions.sh
      ;;
    function)
      $EDITOR ~/scripts/functions.sh
      source ~/scripts/functions.sh
      ;;
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
    path)
      $EDITOR ~/scripts/path.sh
      source ~/scripts/path.sh
      ;;
    skhd)
      if [[ "$platform" == "osx" ]] then;
        $EDITOR ~/.skhdrc
        brew services restart crisidev/chunkwm/chunkwm
      fi
      ;;
    vim)
      $EDITOR ~/.vimrc
      source ~/.vimrc
      ;;
    wm)
      if [[ "$platform" == "osx" ]] then;
        $EDITOR ~/.chunckwm
        brew services restart crisidev/chunkwm/chunkwm
      fi
      ;;
    zsh)
      $EDITOR ~/.zshrc
      source ~/.zshrc
      ;;
    *)
    "edit $1 has not been setup"
    ;;
  esac
}


if [[ "$platform" == "osx" ]] then;

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

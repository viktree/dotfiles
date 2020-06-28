# ---------------------------------------------------------------------------------------
# ---{ My .zshrc } ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   When you start an interactive zsh, it reads ~/.zshrc. This is a good place for
#   contains things that must be done for every shell instance, such as alias and
#   function definitions, shell option settings, completion settings, prompt settings,
#   key bindings, etc.
#

# ---{ Zinit }---------------------------------------------------------------------------
#
# zinit light "agkozak/zsh-z"

# ---{ zplug }---------------------------------------------------------------------------

source "$ZPLUG_HOME/init.zsh"

if check_for_command zplug
then
  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose
  then
      printf "Install? [y/N]: "
      if read -q
      then
        echo
  	zplug install
      fi
  fi

  # Then, source plugins and add commands to $PATH
  zplug load

fi

# ---{ Souce completions }---------------------------------------------------------------

function source_if_file(){ [[ -f $1 ]] && source $1 }
function source_if_possible(){ [[ -e $1 ]] && source $1 }
function check_for_command(){ command -v $1 >/dev/null 2>&1 }
function is_mac(){ [ "$(uname)" = "Darwin" ] }

if check_for_command brew
then FPATH="/usr/local/share/zsh/site-functions":$FPATH
fi

source_if_possible "/usr/local/share/zsh/site-functions"

# Updates PATH for the Google Cloud SDK.
# and enables shell command completion for gcloud.
source_if_file "$GCLOUD_HOME/path.zsh.inc"
source_if_file "$GCLOUD_HOME/completion.zsh.inc"

if check_for_command kubectl
then source <(kubectl completion zsh)
fi


# ---{ Aliases }-------------------------------------------------------------------------

alias cat='bat --paging=never --style=plain'

source_if_file "$ZDOTDIR/aliases.sh"

# Alias things quickly and worry about it later.
# https://news.ycombinator.com/item?id=9869231
function save() {
    echo "alias $1='${@:2}'" >> "$ZDOTDIR/aliases.sh"
    echo "made alias:"
    echo "alias $1='${@:2}'"
    source "$ZDOTDIR/aliases.sh"
}

# ---{ Path Utils }----------------------------------------------------------------------

function prune_path(){
    PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
    export PATH
}

function add_path(){
    echo "PATH_append $1" >> "$HOME/.zshenv"
}

function grep-path(){
    echo -e ${PATH//:/\\n} | rg $1
}

# ---{ rsync Functions }-----------------------------------------------------------------

function copy_to_cdf(){
    rsync -avz uoftcs:~/$1 $(pwd)
}


function copy_from_cdf(){
    rsync -avzh uoftcs:~/$1 $(pwd)
}

# ---{ Other Functions }-----------------------------------------------------------------

function mkcd () {
    mkdir -p $1
    cd $1
}

function bak(){
    cp $1{,.bak}
}

function overview(){
    files_to_ignore=".git|node_modules|bower_components|.DS_Store"
    tree -aC -I $files_to_ignore --dirsfirst "$@"
}

function grep-history(){
    history | grep $1
}

function grep-node(){
    node_apps_to_ignore="Visual|Insomnia|Typhora|Postman|Notion|Uebersicht|Slack"
    ps aux \
        | grep -i node \
        | grep -v $node_apps_to_ignore
}

function kill-program(){
    ps -ef | fzf | awk '{print $2}' | xargs kill -9
}

function kill-node(){
    grep-node $1 | fzf | xargs kill -9
}

function merge-pdf () {
    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$1" "${@:2}"
}

function vwiki(){
    rg --files "$1" "/Volumes/vikram/Dropbox/notebook" | fzf | xargs nvim
}

# Extract many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
function extract() {
    if [ -f "$1" ]
    then
        case "$1" in
            *.tar.bz2)  tar -jxvf "$1"                               ;;
            *.tar.gz)   tar -zxvf "$1"                               ;;
            *.bz2)      bunzip2 "$1"                                 ;;
            *.dmg)      hdiutil mount "$1"                           ;;
            *.gz)       gunzip "$1"                                  ;;
            *.tar)      tar -xvf "$1"                                ;;
            *.tbz2)     tar -jxvf "$1"                               ;;
            *.tgz)      tar -zxvf "$1"                               ;;
            *.zip)      unzip "$1"                                   ;;
            *.ZIP)      unzip "$1"                                   ;;
            *.pax)      cat "$1" | pax -r                            ;;
            *.pax.Z)    uncompress "$1" --stdout | pax -r            ;;
            *.Z)        uncompress "$1"                              ;;
            *) echo "'$1' cannot be extracted/mounted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file to extract"
    fi
}

function services() {
  brew services \
    `echo -e 'list\nstart\nstop' | fzf --header 'brew services'` \
    `brew services list | tail -n +2 | \
      fzf -d' ' --with-nth=1 --preview='brew services list | grep {}' --preview-window=up:1 | \
      cut -d' ' -f1`
}

# GPG_PUBLIC_ID="4EEDCD431B31F8D1"
# if check_for_command gpg
# then
#     git config --global gpg.program gpg
#     git config --global commit.gpgsign false
#     git config --global user.signingkey "$GPG_PUBLIC_ID"
# fi

# ---{ hooks }---------------------------------------------------------------------------

# pipx competions
if check_for_command pipx
then eval "$(register-python-argcomplete pipx)"
fi

if check_for_command nodenv
then eval "$(nodenv init -)"
fi

if check_for_command pyenv
then eval "$(pyenv init -)"
fi

if check_for_command jenv
then eval "$(jenv init -)"
fi

if check_for_command direnv
then eval "$(direnv hook zsh)"
fi

# ---------------------------------------------------------------------------------------

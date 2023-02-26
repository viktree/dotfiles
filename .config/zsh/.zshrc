#!/bin/zsh
# ---------------------------------------------------------------------------------------
# ---{ My .zshrc } ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   When you start an interactive zsh, it reads ~/.zshrc. This is a good place for
#   contains things that must be done for every shell instance, such as alias and
#   function definitions, shell option settings, completion settings, prompt settings,
#   key bindings, etc.
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ---{ bindings }------------------------------------------------------------------------

bindkey -e # e for emacs, v for vim

# ---{ Utility Functions }---------------------------------------------------------------

function check_for_command(){ command -v $1 >/dev/null 2>&1 }
function source_if_file(){ [[ -f $1 ]] && source $1 }
function source_if_possible(){ [[ -e $1 ]] && source $1 }

# ---{ Path Utils }----------------------------------------------------------------------

function prune_path(){
    PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
    export PATH
}

function add_path(){
    echo "PATH_append $1" >> "$HOME/.zshenv" && source "$HOME/.zshenv"
}

function grep-path(){
    echo -e ${PATH//:/\\n} | rg $1
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
    files_to_ignore=".git|node_modules|bower_components|.DS_Store|repo.git"
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

# ---------------------------------------------------------------------------------------

setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt interactive_comments # allow comments in interactive shells

# ---------------------------------------------------------------------------------------

### Added by Zinit's installer

if [[ ! -f $XDG_DATA_HOME/zinit/zinit.git/zinit.zsh ]]
then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$XDG_DATA_HOME/zinit" && command chmod g-rwX "$XDG_DATA_HOME/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$XDG_DATA_HOME/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$XDG_DATA_HOME/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# ---------------------------------------------------------------------------------------

ZINIT_PLUGIN_PATH="$XDG_DATA_HOME/zinit/plugins"

zinit ice blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

autoload compinit
compinit

zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# ogham/exa, replacement for ls
zinit ice wait"3" lucid from"gh-r" as"program" mv"bin/exa* -> exa" pick"exa"
zinit light ogham/exa

if [[ -f "$ZINIT_PLUGIN_PATH/ogham---exa/exa" ]]
then alias ls="$ZINIT_PLUGIN_PATH/ogham---exa/exa"
fi

zinit ice wait lucid id-as"auto"
zinit load hlissner/zsh-autopair

# ---------------------------------------------------------------------------------------

# Load pure theme
zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
zinit light sindresorhus/pure

zinit load MichaelAquilina/zsh-you-should-use

# Scripts built at install (there's single default make target, "install",
# and it constructs scripts by `cat'ing a few files). The make'' ice could also be:
# `make"install PREFIX=$ZPFX"`, if "install" wouldn't be the only default target.
zi ice as"program" pick"$ZPFX/bin/git-*" make"PREFIX=$ZPFX"
zi light tj/git-extras

# ---------------------------------------------------------------------------------------


# if check_for_command direnv
# then
#     eval "$(asdf exec direnv hook zsh)"
#     direnv() { asdf exec direnv "$@"; }
# fi


if check_for_command rtx
then eval "$(rtx activate zsh)"
fi

patch_spotify(){
	spicetify upgrade
	spicetify restore backup apply
}

alias o='open'
alias y='yadm'
alias v='nvim'
alias vim='nvim'

# ---------------------------------------------------------------------------------------

GCLOUD_HOME="$HOME/programs/google-cloud-sdk"
source_if_file "$GCLOUD_HOME/path.zsh.inc"
source_if_file "$GCLOUD_HOME/completion.zsh.inc"

# ---------------------------------------------------------------------------------------

# if check_for_command gpg
# then 
#     export GPG_TTY=$(tty)
#     export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
#     gpgconf --launch gpg-agent  >/dev/null 2>&1
#     gpg-connect-agent updatestartuptty /bye  >/dev/null 2>&1
# fi

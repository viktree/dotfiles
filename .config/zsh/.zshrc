# !/bin/zsh
# ---------------------------------------------------------------------------------------
# ---{ My .zshrc } ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   When you start an interactive zsh, it reads ~/.zshrc. This is a good place for
#   contains things that must be done for every shell instance, such as alias and
#   function definitions, shell option settings, completion settings, prompt settings,
#   key bindings, etc.
#

function source_if_file() {
    [[ -f "$1" ]] && source "$1"
}

function source_if_exists() {
    [[ -e $1 ]] && source $1
}

function check_for_command() {
    command -v $1 >/dev/null 2>&1
}

# ---{ Souce completions }---------------------------------------------------------------

HOMEBREW_PREFIX="/usr/local/opt"
GCLOUD_HOME="$XDG_DATA_HOME/rtx/installs/gcloud/426.0.0"

source_if_file "$HOME/.config/zsh/aliases.zsh"
source_if_file "$HOME/.config/zsh/secrets.sh"

source_if_exists "$HOME/.cargo/env"
source_if_exists "$HOME/IdeaProjects/op-ts-server-core/local-env/local-files/server_core_rc"

source_if_exists "$XDG_CONIG_HOME/zsh/.zprofile"

# Updates PATH for the Google Cloud SDK.
# and enables shell command completion for gcloud.
source_if_file "$GCLOUD_HOME/path.zsh.inc"
source_if_file "$GCLOUD_HOME/completion.zsh.inc"

# if check_for_command kubectl; then
#     kubectl completion zsh > /tmp/kubectl_completion
#     source /tmp/kubectl_completion
#     rm /tmp/kubectl_completion
# fi

# ---{ Path Utils }----------------------------------------------------------------------

function prune-path() {
    PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
    export PATH
}

function add_path() {
    echo "PATH_append $1" >>"$HOME/.zshenv" && source "$HOME/.zshenv"
}

function grep-path() {
    echo -e ${PATH//:/\\n} | rg $1
}

# ---{ Other Functions }-----------------------------------------------------------------

if check_for_command wget; then
    alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"
fi

if check_for_command mitmproxy; then
    alias mitmproxy="mitmproxy --set confdir=$XDG_CONFIG_HOME/mitmproxy"
    alias mitmweb="mitmweb --set confdir=$XDG_CONFIG_HOME/mitmproxy"
fi

alias clear="TERM=xterm /usr/bin/clear"

function mkcd() {
    mkdir -p $1
    cd $1
}

function bak() {
    cp $1{,.bak}
}

function overview() {
    files_to_ignore=".git|node_modules|bower_components|.DS_Store|repo.git"
    tree -aC -I $files_to_ignore --dirsfirst "$@"
}

function grep-history() {
    history | grep $1
}

function grep-node() {
    node_apps_to_ignore="Visual|Insomnia|Typhora|Postman|Notion|Uebersicht|Slack"
    ps aux |
        grep -i node |
        grep -v $node_apps_to_ignore
}

function kill-program() {
    ps -ef | fzf | awk '{print $2}' | xargs kill -9
}

function kill-node() {
    grep-node $1 | fzf | xargs kill -9
}

function merge-pdf() {
    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$1" "${@:2}"
}

# Extract many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
function extract() {
    if [ -f "$1" ]; then
        case "$1" in
        *.tar.bz2) tar -jxvf "$1" ;;
        *.tar.gz) tar -zxvf "$1" ;;
        *.bz2) bunzip2 "$1" ;;
        *.dmg) hdiutil mount "$1" ;;
        *.gz) gunzip "$1" ;;
        *.tar) tar -xvf "$1" ;;
        *.tbz2) tar -jxvf "$1" ;;
        *.tgz) tar -zxvf "$1" ;;
        *.zip) unzip "$1" ;;
        *.ZIP) unzip "$1" ;;
        *.pax) cat "$1" | pax -r ;;
        *.pax.Z) uncompress "$1" --stdout | pax -r ;;
        *.Z) uncompress "$1" ;;
        *) echo "'$1' cannot be extracted/mounted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file to extract"
    fi
}

# ---{ bindings }------------------------------------------------------------------------

bindkey -e # e for emacs, v for vim

# ---{ hooks }---------------------------------------------------------------------------

if check_for_command nvim; then
    export EDITOR='nvim'
fi

if check_for_command sheldon; then
    if [[ ! -d "$XDG_DATA_HOME/sheldon" ]]; then
        mkdir "$XDG_DATA_HOME/sheldon"
    fi
    eval "$(sheldon source)"
fi

if check_for_command rtx; then
    eval "$(rtx activate zsh)"
fi

if check_for_command direnv; then
    eval "$(direnv hook zsh)"
fi

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

if check_for_command mise
then
eval "$(/usr/local/bin/mise activate zsh)"
fi

# ---------------------------------------------------------------------------------------

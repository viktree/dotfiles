#!/bin/bash
# ---------------------------------------------------------------------------------------
# ---{ My ~/.zshenv } -------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#   Unlike the ~/.zprofile, this file is sourced often, and it's a good place to put
#   variables that are subject to change throughout the session such as the PATH
#
#   By setting it in that file, reopening a terminal emulator will start a new Zsh
#   instance with the PATH value updated.

function check_for_command() {
    command -v $1 >/dev/null 2>&1
}

# ---{ XDG Compliance}-------------------------------------------------------------------

# Set XDG Base Directory
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
export XDG_STATE_HOME="$XDG_LOCAL_HOME/state"
export XDG_RUNTIME_DIR="/run/user/$UID"

export HISTFILE="$XDG_STATE_HOME/zsh/history"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export _Z_DATA="$XDG_DATA_HOME/z"

# export KUBECONFIG="$XDG_CONFIG_HOME/kubernetes"
export GCLOUD_HOME="$XDG_DATA_HOME/rtx/installs/gcloud/426.0.0"
export USE_GKE_GCLOUD_AUTH_PLUGIN="True"

export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"

export SSH_AUTH_SOCK="$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export VAULT_ADDR="https://vault.prod.score.internal.buzz"
export VAULT_SKIP_VERIFY=1
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME"/go
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export STACK_ROOT="$XDG_DATA_HOME/stack"

export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export ANDROID_HOME="$XDG_DATA_HOME/android"
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

export MINIKUBE_HOME="$XDG_DATA_HOME/minikube"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"

export PSQL_HISTORY="$XDG_DATA_HOME/psql_history"
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export BAT_THEME="Catppuccin-mocha"

function PATH_append() {
    if [[ -e $1 ]] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1:$PATH"
    fi
}

export USE_GKE_GCLOUD_AUTH_PLUGIN=True

PATH_append "$GCLOUD_HOME/google-cloud-sdk/bin"
PATH_append "$HOME/.spicetify/spicetify"
PATH_append "$HOME/bin"
PATH_append "$HOME/bin/openapitools"
PATH_append "$HOME/go/bin"
PATH_append "/usr/local/bin"
PATH_append "/usr/local/opt/llvm/bin"
PATH_append "/usr/local/sbin"

if check_for_command brew; then
    export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/homebrew/Brewfile"
    HOMEBREW_PREFIX="/usr/local/opt"

    PATH_append "$HOMEBREW_PREFIX/openjdk@11/bin"
fi

export PATH

# ---------------------------------------------------------------------------------------
# ---{ My ~/.zshenv } -------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#   Unlike the ~/.zprofile, this file is sourced often, and it's a good place to put
#   variables that are subject to change throughout the session such as the PATH
#
#   By setting it in that file, reopening a terminal emulator will start a new Zsh
#   instance with the PATH value updated.

function check_for_command(){ command -v $1 >/dev/null 2>&1 }

# ---{ XDG Compliance}-------------------------------------------------------------------

# Set XDG Base Directory
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export GCLOUD_HOME="$HOME/programs/google-cloud-sdk"
export USE_GKE_GCLOUD_AUTH_PLUGIN="True"

export SSH_AUTH_SOCK="$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"

export VAULT_ADDR="https://vault.prod.score.internal.buzz"
export VAULT_SKIP_VERIFY=1

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

export BAT_THEME="Catppuccin-mocha"

function PATH_append(){
    if [[ -e $1 ]] && [[ ":$PATH:" != *":$1:"* ]]
    then PATH="$1:$PATH"
    fi
}

PATH_append "/usr/local/bin"
PATH_append "/usr/local/sbin"
PATH_append "$HOME/bin"
PATH_append "$HOME/bin/openapitools"
PATH_append "$HOME/go/bin"
PATH_append "$GCLOUD_HOME/google-cloud-sdk/bin"
PATH_append "$HOME/.spicetify/spicetify"

if check_for_command brew
then
    export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/homebrew/Brewfile"
    HOMEBREW_PREFIX="/usr/local/opt"

    PATH_append "$HOMEBREW_PREFIX/openjdk@11/bin"
fi

export PATH


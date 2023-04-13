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
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export NIX_PATH="$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export GCLOUD_HOME="$HOME/programs/google-cloud-sdk"

export SSH_AUTH_SOCK="$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"

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

PATH_append "/usr/local/sbin"
PATH_append "$HOME/bin"
PATH_append "$HOME/go/bin"
PATH_append "$GCLOUD_HOMEgoogle-cloud-sdk/bin"
PATH_append "$HOME/programs/nvim-osx64/bin"

if check_for_command brew
then
    export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/homebrew/Brewfile"
    HOMEBREW_PREFIX="/usr/local/opt"

    PATH_append "$HOMEBREW_PREFIX/openjdk@11/bin"
    PATH_append "$HOMEBREW_PREFIX/helm@2/bin"
fi

if check_for_command asdf
then PATH_append "$HOME/.asdf/installs/java/openjdk-11/bin"
fi

if check_for_command rtx
then PATH_append "$HOME/.local/share/rtx/installs/golang/1.20/go/bin"
fi

if check_for_command perl
then PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')" 
fi

export PATH



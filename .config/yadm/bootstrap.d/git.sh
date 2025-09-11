#!/bin/sh

is_mac() {
    [ "$(uname)" = "Darwin" ]
}

check_for_command() {
    command -v "$1" >/dev/null 2>&1
}

# Setup XDG Base Directory
# Having these exported ensures that programs are installed to the correct locations
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export GITCONFIG_DIR="$XDG_CONFIG_HOME/git"

# Save password
if is_mac; then
    git config --global credential.helper osxkeychain
else
    git config --global credential.helper cache
fi
# ---------------------------------------------------------------------------------------
# ---{ My ~/.zshenv } -------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   Unlike the ~/.zprofile, this file is sourced often, and it's a good place to put
#   variables that are subject to change throughout the session such as the PATH
#
#   By setting it in that file, reopening a terminal emulator will start a new Zsh
#   instance with the PATH value updated.
#
# ---{ XDG Compliance}-------------------------------------------------------------------

# Set XDG Base Directory
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

# Zsh configuration directory
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

check_for_command(){ command -v $1 >/dev/null 2>&1 }
source_if_file(){ [[ -f $1 ]] && source $1 }
source_if_possible(){ [[ -e $1 ]] && source $1 }
PATH_append() { [[ -e $1 ]] && [[ ":$PATH:" != *":$1:"* ]] && PATH="$PATH:$1"; }

# ---------------------------------------------------------------------------------------

HOMEBREW_PREFIX="/opt/homebrew/share"

export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/homebrew/Brewfile"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANT_HOME="$HOMEBREW_PREFIX/ant/libexec"
export MAVEN_HOME="$HOMEBREW_PREFIX/maven"
export GRADLE_HOME="$HOMEBREW_PREFIX/gradle"
export ANDROID_HOME="$HOMEBREW_PREFIX/android-sdk"
export ANDROID_NDK_HOME="$HOMEBREW_PREFIX/android-ndk"

# ---------------------------------------------------------------------------------------

PATH_append "/opt/homebrew/bin"
PATH_append "$(gem environment gemdir)/bin"
PATH_append "$ANDROID_HOME/build-tools/19.1.0"
PATH_append "$ANDROID_HOME/emulator"
PATH_append "$ANDROID_HOME/platform-tools"
PATH_append "$ANDROID_HOME/tools"
PATH_append "$ANDROID_HOME/tools/bin"
PATH_append "$ANT_HOME/bin"
PATH_append "$GRADLE_HOME/bin"
PATH_append "$HOME/.spicetify"
# PATH_append "$HOME/bin"
PATH_append "$XDG_LOCAL_HOME/bin"
PATH_append "$HOME/programs/google-cloud-sdk/bin"
PATH_append "$HOME/programs/nvim-osx64/bin"
PATH_append "$MAVEN_HOME/bin"


if check_for_command nodenv; then
    export NODENV_VERSION="24.11.1"
    PATH_append "${HOME}/.nodenv/versions/${NODENV_VERSION}/bin"
fi

if check_for_command pnpm; then
    export PNPM_HOME="${XDG_DATA_HOME}/pnpm"
    mkdir -p "${PNPM_HOME}"
    PATH_append "${PNPM_HOME}"
fi

# ---------------------------------------------------------------------------------------

if check_for_command gpg; then
    export GPG_TTY=$(tty)
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

# gcloud modifies environment, not just interactive shell
#
# updates PATH for the Google Cloud SDK.
source_if_file "$HOME/programs/google-cloud-sdk/path.zsh.inc"

# enables shell command completion for gcloud.
source_if_file "$HOME/programs/google-cloud-sdk/completion.zsh.inc"

# op plugins
source_if_file "${XDG_CONFIG_HOME}/op/plugins.sh"


export PATH

#!/bin/zsh
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
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="/run/user/$UID"

export HISTFILE="$XDG_STATE_HOME/zsh/history"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export ANDROID_HOME="$XDG_DATA_HOME/android"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history"
export KERAS_HOME="${XDG_STATE_HOME}/keras"

export GNUPGHOME="$XDG_DATA_HOME/gnupg"

export MINIKUBE_HOME="$XDG_DATA_HOME/minikube"

export GCLOUD_HOME="$HOME/programs/google-cloud-sdk"
export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"

export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"

export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# ---{ Utility Functions }---------------------------------------------------------------

function check_for_command(){ command -v $1 >/dev/null 2>&1 }
function source_if_file(){ [[ -f $1 ]] && source $1 }
function source_if_possible(){ [[ -e $1 ]] && source $1 }

# ---------------------------------------------------------------------------------------

if check_for_command gpg
then export GPG_TTY=$(tty)
fi

function PATH_append(){
    if [[ -e $1 ]] && [[ ":$PATH:" != *":$1:"* ]]
    then PATH="$PATH:$1"
    fi
}

# if check_for_command direnv
# then
#     eval "$(asdf exec direnv hook zsh)"
#     direnv() { asdf exec direnv "$@"; }
# fi


if check_for_command zoxide
then eval "$(zoxide init zsh)"
fi

PATH_append "$HOME/bin"
PATH_append "$GCLOUD_HOME/bin"
PATH_append "$PNPM_HOME"

PATH_append "$HOME/programs/nvim-macos/bin"

PATH_append "/opt/homebrew/bin"

if check_for_command brew
then
    export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/homebrew/Brewfile"
    PATH_append "/opt/homebrew/bin"
    PATH_append "/usr/local/bin"

    HOMEBREW_PREFIX="/opt/homebrew/share"
    export ANT_HOME="$HOMEBREW_PREFIX/ant/libexec"
    export MAVEN_HOME="$HOMEBREW_PREFIX/maven"
    export GRADLE_HOME="$HOMEBREW_PREFIX/gradle"
    export ANDROID_HOME="$HOMEBREW_PREFIX/android-sdk"
    export ANDROID_NDK_HOME="$HOMEBREW_PREFIX/android-ndk"

    PATH_append "$ANT_HOME/bin"
    PATH_append "$MAVEN_HOME/bin"
    PATH_append "$GRADLE_HOME/bin"
    PATH_append "$ANDROID_HOME/tools"
    PATH_append "$ANDROID_HOME/platform-tools"
    PATH_append "$ANDROID_HOME/build-tools/19.1.0"


    PATH_append "/opt/coreutils/libexec/gnubin"
    PATH_append "/opt/findutils/libexec/gnubin"
    PATH_append "/opt/gnu-sed/libexec/gnubin"
    PATH_append "/opt/gnu-tar/libexec/gnubin"
    PATH_append "/opt/gnu-which/libexec/gnubin"
    PATH_append "/opt/grep/libexec/gnubin"
fi

if check_for_command gem
then PATH_append "$(gem environment gemdir)/bin"
fi

export ANDROID_HOME="$HOME/Library/Android/sdk"

PATH_append "$ANDROID_HOME/emulator "
PATH_append "$ANDROID_HOME/tools "
PATH_append "$ANDROID_HOME/tools/bin "
PATH_append "$ANDROID_HOME/platform-tools"

PATH_append "$HOME/.spicetify"

emacs-mac(){
/opt/homebrew/opt/emacs-mac/bin/emacs
}

# Prune path
if check_for_command pearl
then PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
fi

export PATH

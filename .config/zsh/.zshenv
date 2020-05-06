# ---------------------------------------------------------------------------------------
# ---{ My ~/.zshenv } -------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
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

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Follow XDG Basedir Spec
export ATOM_HOME="$XDG_DATA_HOME/atom"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export HISTFILE="$XDG_DATA_HOME/bash/history"
export HISTFILE="$XDG_DATA_HOME/zsh/history"
export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/brew/config"
export IPYTHONDIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export KITTY_CONFIG_DIRECTORY="$XDG_CONFIG_HOME/kitty"
export LESSHISTFILE="$XDG_CONFIG_HOME/less/history"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch/config"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export WAKATIME_HOME="$XDG_CONFIG_HOME/wakatime"
export _Z_DATA="$XDG_DATA_HOME/z"

# ---{ PROGRAMS }------------------------------------------------------------------------

local vikram='/Volumes/Vikram'
local build_tool_version="29.0.1"
local node_version="10"
local BREW_PREFIX="/usr/local"

export DEFAULT_USER=`whoami`
export LANG="en_US.UTF-8"

export HISTSIZE=10000
export SAVEHIST=10000

export ZPLUG_HOME="$BREW_PREFIX/opt/zplug"

# ---------------------------------------------------------------------------------------

export HOMEBREW_CASK_OPTS="--appdir=/Applications --fontdir=/Library/Fonts"
export HOMEBREW_NO_ANALYTICS=1

if check_for_command ssh
then export SSH_KEY_PATH="$HOME/.ssh/rsa_id"
fi

if check_for_command gpg
then export GPG_TTY=$(tty)
fi

if check_for_command nvim
then export EDITOR='nvim'
fi

if check_for_command go
then
	export GOPATH="/Volumes/vikram/go"
	export PATH=$PATH:$GOPATH/bin
fi

if check_for_command docker
then export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
fi

if check_for_command jenv
then export JENV_ROOT="$XDG_DATA_HOME/jenv"
fi

if check_for_command ant
then export ANT_HOME="$BREW_PREFIX/opt/ant"
fi

if check_for_command maven
then export MAVEN_HOME="$BREW_PREFIX/opt/maven"
fi

if check_for_command gradle
then export GRADLE_HOME="$BREW_PREFIX/opt/gradle"
fi

if check_for_command ndk
then export ANDROID_NDK_HOME="$BREW_PREFIX/opt/android-ndk"
fi

if check_for_command pyenv
then export PYENV_VERSION="2.7"
fi

if [[ -e "/Library/TeX/texbin" ]]
then export TEX_HOME="/Library/TeX/texbin"
fi

if check_for_command fzf && check_for_command rg
then
	export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git} !{node_modules}" 2>/dev/null'
	export FZF_CTRL_T_COMMAND='rg --files --hidden --follow -g "!{.git} !{node_modules}" 2>/dev/null'
fi

# ---------------------------------------------------------------------------------------

if [[ -d "$vikram" ]]
then
	if [[ -d "$vikram/Android/sdk" ]]
	then
		export ANDROID_HOME="$vikram/Android/sdk"
		export ANDROID_SDK_ROOT="$vikram/Android/sdk"
		export ANDROID_SDK=$ANDROID_SDK_ROOT
	fi
	if [[ -d "$vikram/google-cloud-sdk" ]]
	then export GCLOUD_HOME="$vikram/google-cloud-sdk"
	fi
fi


# ---------------------------------------------------------------------------------------

function PATH_append(){
	if [[ -e $1 ]] && [[ ":$PATH:" != *":$1:"* ]]
	then PATH="$1:$PATH"
	fi
}

PATH_append "$ANDROID_HOME/build-tools/$build_tool_version"
PATH_append "$ANDROID_HOME/emulator"
PATH_append "$ANDROID_HOME/platform-tools"
PATH_append "$ANDROID_HOME/tools"
PATH_append "$ANT_HOME"
PATH_append "$GCLOUD_HOME/bin"
PATH_append "$BREW_PREFIX/bin"
PATH_append "$BREW_PREFIX/opt/node@$node_version/bin"
PATH_append "$BREW_PREFIX/opt/sqlite/bin"
PATH_append "$BREW_PREFIXopt/llvm/bin"
PATH_append "$BREW_PREFIX/sbin"
PATH_append "$GOPATH/bin"
PATH_append "$GRADLE_HOME"
PATH_append "$HOME/.cargo/bin"
PATH_append "$HOME/.local/bin"
PATH_append "$HOME/.yarn/bin"
PATH_append "$HOME/bin"
PATH_append "$MAVEN_HOME"
PATH_append "$TEX_HOME"
PATH_append "$XDG_CONFIG_HOME/yarn/global/node_modules/.bin"
PATH_append "$XDG_DATA_HOME/bin"
PATH_append "$HOME/.poetry/bin"

export PATH

# ---------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------
# ---{ My ~/.zshenv } -------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   Unlike the ~/.zprofile, this file is sourced often, and it's a good place to put
#   variables that are subject to change throughout the session such as the PATH
#
#   By setting it in that file, reopening a terminal emulator will start a new Zsh
#   instance with the PATH value updated.

# ---{ Utility Functions }---------------------------------------------------------------

function check_for_command(){ command -v $1 >/dev/null 2>&1 }
function source_if_file(){ [[ -f $1 ]] && source $1 }
function source_if_possible(){ [[ -e $1 ]] && source $1 }

# ---------------------------------------------------------------------------------------

if check_for_command nvm
then
    export NVM_DIR="$HOME/.nvm" # You probably have this line already
    export NODE_VERSIONS="${NVM_DIR}/versions/node"
    export NODE_VERSION_PREFIX="v"

    export NVM_AUTO_USE=true
    if [[ -e '$HOME/.nvm/usr/local/opt/nvm/nvm.sh' ]]
    then
        export NVM_DIR="$HOME/.nvm/usr/local/opt/nvm/nvm.sh"
    fi
fi

if check_for_command gpg
then export GPG_TTY=$(tty)
fi

function PATH_append(){
    if [[ -e $1 ]] && [[ ":$PATH:" != *":$1:"* ]]
    then PATH="$1:$PATH"
    fi
}

source_if_file "/opt/homebrew/opt/asdf/libexec/asdf.sh"

if check_for_command direnv
then
    direnv() { asdf exec direnv "$@"; }
else if check_for_command asdf
    asdf plugin-add direnv
    asdf install direnv latest
    asdf global direnv latest
fi

export HOMEBREW_BUNDLE_FILE="$XDG_CONFIG_HOME/homebrew/Brewfile"      
HOMEBREW_PREFIX="/usr/local/opt"

PATH_append "$HOME/bin"
PATH_append "$HOME/programs/google-cloud-sdk/bin"


export PATH

# ---------------------------------------------------------------------------------------
# ---{ My ~/.zshenv } -------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   Unlike the ~/.zprofile, this file is sourced often, and it's a good place to put
#   variables that are subject to change throughout the session such as the PATH
#
#   By setting it in that file, reopening a terminal emulator will start a new Zsh
#   instance with the PATH value updated.

# ---{ Pre-load Checks }-----------------------------------------------------------------
#
#   -e    exit on first error
#   -u    exit when an undefined variable
#   -o    pipefail exit when any cmd in pipe sequence has exitcode != 0
#   -x    print all commands
#

set -euo pipefail

# ---{ PROGRAMS }------------------------------------------------------------------------

function PATH_append(){
    if [[ -e $1 ]] && [[ ":$PATH:" != *":$1:"* ]] then;
        PATH="$1:$PATH"
    fi
}

function MANPATH_append(){
    if [[ -e $1 ]] && [[ ":$MANPATH:" != *":$1:"* ]] then;
        MANPATH="$1:$MANPATH"
    fi
}

PATH_append "$HOME/.local/bin"

if [[ -e "$HOME/bin:/usr/local/bin"  ]]; then
    BASH_LEFTOVERS=$HOME/bin:/usr/local/bin
    PATH_append "$BASH_LEFTOVERS"
fi

if [[ -e "/usr/local/opt/ant" ]]; then
    export ANT_HOME="/usr/local/opt/ant"
    PATH_append "$ANT_HOME"
fi

if [[ -e "/usr/local/opt/maven" ]]; then
    export MAVEN_HOME="/usr/local/opt/maven"
    PATH_append "$MAVEN_HOME"
fi

if [[ -e "/usr/local/opt/gradle" ]]; then
    export GRADLE_HOME="/usr/local/opt/gradle"
    PATH_append "$GRADLE_HOME"
fi

if [[ -e "/usr/local/opt/android-sdk" ]]; then
    export ANDROID_HOME="/usr/local/opt/android-sdk"
    PATH_append "$ANDROID_HOME/tools"
    PATH_append "$ANDROID_HOME/platform-tools"
    PATH_append "$ANDROID_HOME/build-tools/19.1.0"
fi

# Check if yarn package manager is installed. If it is then add it to $PATH.
# https://yarnpkg.com
if (( $+commands[yarn] )) then
    PATH_append `yarn global bin`
    PATH_append "$HOME/.yarn/bin"
    PATH_append "$HOME/.config/yarn/global/node_modules/.bin"
fi

PATH_append "$HOME/.vs-kubernetes/tools/draft/darwin-amd64/draft"
PATH_append "$HOME/google-cloud-sdk/bin/kubectl"

MANPATH_append '/usr/local/man'
MANPATH_append '/usr/share/man'
MANPATH_append '/usr/local/share/man'

export PATH
export MANPATH


# ---{ Post-load Checks }----------------------------------------------------------------
#
#   -e    exit on first error
#   -u    exit when an undefined variable
#   -o    pipefail exit when any cmd in pipe sequence has exitcode != 0
#   -x    print all commands
#

set +euo pipefail

# ---------------------------------------------------------------------------------------

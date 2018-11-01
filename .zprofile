# ---------------------------------------------------------------------------------------
# ---{ My ~\.zprofile } -----------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   The file ~/.profile is loaded by login shells. The login shell is the first process
#   that is started when you log in in text mode, for example on a text console or via
#   ssh. It serves the same function as the ~/.bash_profile, serves when the default
#   shell is bash except that the default shell is zsh.
#
#   Typically, ~/.profile contains environment variable definitions, and might start some
#   programs that you want to run once when you log in or for the whole session.
#
# ---{ Bash compatible }-----------------------------------------------------------------
#
#   The easiest solution to both work with zsh and run ~/.profile is to create a 
#   ~/.zprofile that enters sh emulation mode while it runs ~/.profile

if [[ -f '~/.profile' ]] then
  emulate sh -c '. ~/.profile'.
fi

# ---{ PLATFORM }------------------------------------------------------------------------
#
#   Set the operating system to an environment variable so that we can easily reference
#   it when we want to have aliases or functions that are platform specific.

PLATFORM='unknown'
unamestr="$(uname)"

case "$unamestr" in
    "Darwin")
        PLATFORM='osx'
        ;;
    "Linux")
        PLATFORM='linux'
        ;;
    "FreeBSD")
        PLATFORM='freebsd'
        ;;
    *)
        ;;
esac

case "$PLATFORM" in
    "osx")
        # Set all Hombrew apps to correct location.
        export HOMEBREW_CASK_OPTS="--appdir=/Applications"
        ;;
    "linux")
        ;;
    "freebsd")
        ;;
    *)
        ;;
esac

export PLATFORM
export DEFAULT_USER=`whoami`
export LANG=en_US.UTF-8
export SSH_KEY_PATH="~/.ssh/rsa_id"


# ---{ PATH }----------------------------------------------------------------------------
#
#   PATH is an environmental variable that tells the shell which directories to search
#   when looking for for executable files
#

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Check if yarn package manager is installed. If it is then add it to $PATH.
# https://yarnpkg.com

if (( $+commands[yarn] )) then
  export PATH="$PATH:`yarn global bin`"
fi

export PATH=$HOME/.local/bin:$PATH
export PATH=/Users/tintinux/Library/Python/3.7/bin:$PATH

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vikram.v/google-cloud-sdk/path.zsh.inc' ]
  then . '/Users/vikram.v/google-cloud-sdk/path.zsh.inc' 
fi

# ---{ PROGRAMS }------------------------------------------------------------------------

# Set the default editor
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='code'
else
  export EDITOR='nvim'
fi

# Set the path for go-lang
export GOPATH=$HOME

export NVM_DIR="$HOME/.nvm/usr/local/opt/nvm/nvm.sh"

export MANPATH="/usr/local/man:$MANPATH"

# ---------------------------------------------------------------------------------------

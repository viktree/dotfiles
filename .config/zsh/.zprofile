# ---------------------------------------------------------------------------------------
# ---{ My ~/.zprofile } -----------------------------------------------------------------
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
#   Variables that are more prone to change, like $PATH declared in .zshenv
#
# ---{ Pre-load Checks }-----------------------------------------------------------------
#
#   -e    exit on first error
#   -u    exit when an undefined variable
#   -o    pipefail exit when any cmd in pipe sequence has exitcode != 0
#   -x    print all commands
#

set -euo pipefail

# ---{ Utility Functions }---------------------------------------------------------------

function check_for_command(){ command -v $1 >/dev/null 2>&1 }

# ---{ OS Setiings }---------------------------------------------------------------------
#
#   Set some operating system specific stuff

PLATFORM='unknown'
case "$(uname)" in
    "Darwin") PLATFORM='osx';;
    "Linux") PLATFORM='linux';;
    "FreeBSD") PLATFORM='freebsd';;
    *);;
esac

export DEFAULT_USER=`whoami`
export LANG="en_US.UTF-8"

function is_mac(){ [[ "$PLATFORM" == "osx" ]]  }
function is_linux(){ [[ "$PLATFORM" == "linux" ]]  }
function is_freebsd(){ [[ "$PLATFORM" == "freebsd" ]]  }
function is_windows(){ grep -q Microsoft /proc/version }

# ---{ XDG Compliance}-------------------------------------------------------------------

# Set XDG Base Directory
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# ---------------------------------------------------------------------------------------

# ---{ PROGRAMS }------------------------------------------------------------------------

if is_mac
then
    # List the iPhone simulator as an application
    if [[ -f "/Applications/Xcode.app/Contents/Applications/iPhone\ Simulator.app"  ]]
    then ln -s "/Applications/Xcode.app/Contents/Applications/iPhone\ Simulator.app /Applications"
    fi

    if [[ -f "$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock" ]]
    then 
        mkdir -p "$HOME/.1password"
        ln -s "$HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock" "$HOME/.1password/agent.sock"
    fi
fi


export EDITOR='nvim'

# ---{ hooks }---------------------------------------------------------------------------

if check_for_command brew
then eval "$(/opt/homebrew/bin/brew shellenv)"
fi

setopt SHARE_HISTORY

# ---{ Post-load Checks }----------------------------------------------------------------
#
#   -e    exit on first error
#   -u    exit when an undefined variable
#   -o    pipefail exit when any cmd in pipe sequence has exitcode != 0
#   -x    print all commands
#

set +euo pipefail

# ---------------------------------------------------------------------------------------

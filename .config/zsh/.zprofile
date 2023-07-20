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
function source_if_file(){ [[ -f $1 ]] && source $1 }
function source_if_possible(){ [[ -e $1 ]] && source $1 }

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
# export SSH_KEY_PATH="~/.ssh/rsa_id"

function is_mac(){ [[ "$PLATFORM" == "osx" ]]  }
function is_linux(){ [[ "$PLATFORM" == "linux" ]]  }
function is_freebsd(){ [[ "$PLATFORM" == "freebsd" ]]  }
function is_windows(){ grep -q Microsoft /proc/version }

# ---{ Set default programs }------------------------------------------------------------

# List the iPhone simulator as an application
if [[ -f "/Applications/Xcode.app/Contents/Applications/iPhone\ Simulator.app"  ]]
then ln -s "/Applications/Xcode.app/Contents/Applications/iPhone\ Simulator.app /Applications"
fi

# if [[ -e '/usr/local/bin/code' ]]
# then export EDITOR='/usr/local/bin/code --wait'
# elif check_for_command nvim
# then export EDITOR="nvim"
# fi

if check_for_command nvim
then
    export EDITOR='nvim'
    export VISUAL='nvim'
fi

if check_for_command less
then
    # Set the default Less options.
    # Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
    # Remove -X and -F (exit if the content fits on one screen) to enable it.
    export LESS='-F -g -i -M -R -S -w -X -z-4'
    export PAGER='less'
fi

if check_for_command kitty
then export TERMINAL="kitty"
fi

if check_for_command gpg
then export GPG_TTY=$(tty)
fi

# ---{ load secrets }--------------------------------------------------------------------

export HOME_SERVICES_PG_USER_NAME="vikram.v"
export HOME_SERVICES_PG_PASSWORD=$(pass hs/cloudsql/vikram.v) || true

export JIRA_API_TOKEN=$(pass ecobee/JIRA_API_TOKEN) || true

# ---{ Post-load Checks }----------------------------------------------------------------
#
#   -e    exit on first error
#   -u    exit when an undefined variable
#   -o    pipefail exit when any cmd in pipe sequence has exitcode != 0
#   -x    print all commands
#

set +euo pipefail

# ---------------------------------------------------------------------------------------

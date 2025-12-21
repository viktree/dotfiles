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
# ---------------------------------------------------------------------------------------

# # List the iPhone simulator as an application
# if [[ -f "/Applications/Xcode.app/Contents/Applications/iPhone\ Simulator.app"  ]]
# then
#     ln -s "/Applications/Xcode.app/Contents/Applications/iPhone\ Simulator.app /Applications"
# fi

export LANG="en_US.UTF-8"

if command -v zed >/dev/null 2>&1; then
    export EDITOR="zed"
fi

if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
fi

if command -v nodenv >/dev/null 2>&1; then
    eval "$(nodenv init - --no-rehash zsh)"
fi

# ---------------------------------------------------------------------------------------

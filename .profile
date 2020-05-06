# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# Set XDG Base Directory
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

if check_for_command vim
then export EDITOR="vim"
fi

function check_for_command(){
    command -v $1 >/dev/null 2>&1
}

function PATH_append(){
    if [[ -e $1 || -d $1 ]]
    then
        if [[ ":$PATH:" != *":$1:"* ]]
        then PATH="$1:$PATH"
        fi
    fi
}

export CARGO_HOME="$XDG_DATA_HOME/cargo"

# python virtual environments
export WORKON_HOME="$HOME/.virtualenvs"
export VIRTUALENVWRAPPER_PYTHON="/usr/bin/python3"

export PYENV_ROOT="$HOME/.pyenv"
PATH_append "$PYENV_ROOT/bin"
PATH_append "$HOME/.poetry/bin"

# if running bash
if [ -n "$BASH_VERSION" ]
then
    if [ -f "$HOME/.bashrc" ]
    then source "$HOME/.bashrc"
    fi
fi

PATH_append "$HOME/bin"
PATH_append "$HOME/.local/bin"

# Adds the CUDA compiler to the PATH
export CUDA_HOME="/usr/local/cuda"
export LD_LIBRARY_PATH=$CUDA_HOME/lib64:$LD_LIBRARY_PATH
PATH_append "$CUDA_HOME/bin"


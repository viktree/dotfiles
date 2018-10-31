#!/bin/sh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export LDFLAGS="-L/usr/local/opt/icu4c/lib"
export LDFLAGS="-L/usr/local/opt/readline/lib"
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export LDFLAGS="-L/usr/local/opt/sqlite/lib"

export CPPFLAGS="-I/usr/local/opt/icu4c/include"
export CPPFLAGS="-I/usr/local/opt/readline/include"
export CPPFLAGS="-I/usr/local/opt/openssl/include"
export CPPFLAGS="-I/usr/local/opt/sqlite/include"

export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/Library/Python/3.7/bin:$PATH
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/icu4c/sbin:$PATH"
export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/opt/sqlite/bin:$PATH"

export NVM_DIR="$HOME/.nvm/usr/local/opt/nvm/nvm.sh"


export PATH="$PATH:$HOME/.config/nvim/plugged/vim-superman/bin"

# sup yarn
# https://yarnpkg.com

if (( $+commands[yarn] ))
then
  export PATH="$PATH:`yarn global bin`"
fi

#  export MANPATH="/usr/local/man:$MANPATH"

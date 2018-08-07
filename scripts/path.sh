#!/bin/sh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH=$HOME/.local/bin:$PATH
export PATH=/Users/tintinux/Library/Python/3.7/bin:$PATH
export NVM_DIR="$HOME/.nvm/usr/local/opt/nvm/nvm.sh"

# sup yarn
# https://yarnpkg.com

if (( $+commands[yarn] ))
then
  export PATH="$PATH:`yarn global bin`"
fi

 # export MANPATH="/usr/local/man:$MANPATH"
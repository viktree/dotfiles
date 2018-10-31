# ---------------------------------------------------------------------------------------
# ---{ My .zshrc } ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="avit"

# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting
         node npm python pip)

# ---{ Auto-Complete }-------------------------------------------------------------------

CASE_SENSITIVE="true"
COMPLETION_WAITING_DOTS="true"

source $ZSH/oh-my-zsh.sh
bindkey '^ ' autosuggest-accept
if [ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

 # User configuration
fpath=(~/.zsh/completions $fpath)
autoload -U compinit && compinit


# ---{ Better History }------------------------------------------------------------------

setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

HISTSIZE=10000
SAVEHIST=10000
cfg-history() { $EDITOR $HISTFILE ;}

# ---------------------------------------------------------------------------------------

export EDITOR='code'
alias reload="source ~/.zshrc"
source ~/scripts/aliases.sh
# source ~/scripts/functions.sh
source ~/scripts/path.sh
source ~/scripts/platform.sh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

eval "$(direnv hook zsh)"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/vikram.v/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/vikram.v/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/vikram.v/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/vikram.v/google-cloud-sdk/completion.zsh.inc'; fi
if [ /Users/vikram.v/google-cloud-sdk/bin/kubectl ]; then source <(kubectl completion zsh); fi

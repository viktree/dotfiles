# ---------------------------------------------------------------------------------------
# ---{ My .zshrc } ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   When you start an interactive zsh, it reads ~/.zshrc. This is a good place for
#   contains things that must be done for every shell instance, such as alias and
#   function definitions, shell option settings, completion settings, prompt settings,
#   key bindings, etc.
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ---{ Utility Functions }---------------------------------------------------------------

check_for_command(){ command -v $1 >/dev/null 2>&1 }
source_if_file(){ [[ -f $1 ]] && source $1 }
source_if_possible(){ [[ -e $1 ]] && source $1 }

# ---{ Other Functions }-----------------------------------------------------------------

ZDOTDIR="/Users/vikramvenkataramanan/.config/zsh"

source_if_file "${ZDOTDIR}/aliases.zsh"
source_if_file "${ZDOTDIR}/aliases.zsh"
source_if_file "${ZDOTDIR}/extract.zsh"
source_if_file "${ZDOTDIR}/onepassword.zsh"
source_if_file "${ZDOTDIR}/paths.zsh"
source_if_file "${ZDOTDIR}/spicetify.zsh"
source_if_file "${ZDOTDIR}/utils.zsh"

# ---------------------------------------------------------------------------------------

bindkey -e # e for emacs, v for vim

setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt interactive_comments # allow comments in interactive shells

# ---------------------------------------------------------------------------------------

### Added by Zinit's installer

if [[ ! -f $XDG_DATA_HOME/zinit/zinit.git/zinit.zsh ]]
then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$XDG_DATA_HOME/zinit" && command chmod g-rwX "$XDG_DATA_HOME/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$XDG_DATA_HOME/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$XDG_DATA_HOME/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# ---------------------------------------------------------------------------------------

ZINIT_PLUGIN_PATH="$XDG_DATA_HOME/zinit/plugins"

zinit ice blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

autoload compinit
compinit

zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

# ogham/exa, replacement for ls
zinit ice wait"3" lucid from"gh-r" as"program" mv"bin/exa* -> exa" pick"exa"
zinit light ogham/exa

[[ -f "$ZINIT_PLUGIN_PATH/ogham---exa/exa" ]] && alias ls="$ZINIT_PLUGIN_PATH/ogham---exa/exa"

zinit ice wait lucid id-as"auto"
zinit load hlissner/zsh-autopair

# ---------------------------------------------------------------------------------------

# Load pure theme
zinit ice pick"async.zsh" src"pure.zsh" # with zsh-async library that's bundled with it.
zinit light sindresorhus/pure

# ---------------------------------------------------------------------------------------

# source_if_file "/opt/homebrew/opt/asdf/libexec/asdf.sh"

# if check_for_command gemini; then
#     opdev export GEMINI_API_KEY
# fi

if check_for_command zoxide; then
    eval "$(zoxide init zsh)"
fi

if check_for_command direnv; then
    eval "$(direnv hook zsh)"
fi

if check_for_command mise; then
    eval "$(mise activate zsh)"
fi

# ---------------------------------------------------------------------------------------

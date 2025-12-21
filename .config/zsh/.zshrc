# ---------------------------------------------------------------------------------------
# ---{ My .zshrc } ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   When you start an interactive zsh, it reads ~/.zshrc. This is a good place for
#   contains things that must be done for every shell instance, such as alias and
#   function definitions, shell option settings, completion settings, prompt settings,
#   key bindings, etc.
#
# ---------------------------------------------------------------------------------------

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ---------------------------------------------------------------------------------------

# --- History settings ---
export HISTSIZE=10000
export SAVEHIST=10000
# ----------------------

# carefull about the order
optional_hooks=(
    conda
    gpg
    zoxide
    mise
)

personal_scripts=(
  aliases.zsh
  extract.zsh
  # onepassword.zsh
  paths.zsh
  spicetify.zsh
  utils.zsh

  # this needs to be loaded last
  hooks.zsh
)

fpath=(
  $HOME/.docker/completions
  $HOME/programs/google-cloud-sdk/completion.zsh.inc
  $XDG_DATA_HOME/zinit/zinit.git/completions

  # keep existing paths at the end
  $fpath
)

# ---------------------------------------------------------------------------------------

autoload -Uz compinit
compinit -u

check_for_command(){ command -v $1 >/dev/null 2>&1 }
source_if_file(){ [[ -f $1 ]] && source $1 }

source_if_file "$ZDOTDIR/zinit-setup.zsh"
source_if_file "$ZDOTDIR/opts.zsh"

for script in "${personal_scripts[@]}"; do
    source_if_file "$ZDOTDIR/$script"
done

if check_for_command "conda"; then
    __conda_setup="$("$HOME/radioconda/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
    if [[ $? -eq 0 ]]; then
        eval "$__conda_setup"
    else
        source_if_file "$HOME/radioconda/etc/profile.d/conda.sh"
    fi
    unset __conda_setup
    conda deactivate 2>/dev/null
fi

if check_for_command "gpg"; then
    export GPG_TTY=$(tty)
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
fi

if check_for_command "zoxide"; then
    eval "$(zoxide init zsh)"
fi

if check_for_command "mise"; then
    eval "$(mise activate zsh)"
fi

# ---------------------------------------------------------------------------------------
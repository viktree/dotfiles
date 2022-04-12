#!/bin/sh

name="Vikram Venkataranan"
email="14256527+viktree@users.noreply.github.com"
username="viktree"

is_mac() {
    [ "$(uname)" = "Darwin" ]
}

check_for_command() {
    command -v "$1" >/dev/null 2>&1
}

# Setup XDG Base Directory
# Having these exported ensures that programs are installed to the correct locations
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

export GITCONFIG_DIR="$XDG_CONFIG_HOME/git"

git config --global user.name "$name"
git config --global user.email "$email"
git config --global user.username "$username"

git config --global github.user "$username"

git config --global rebase.autoStash "true"

git config --global core.editor "$EDITOR"

if [ -f "$GITCONFIG_DIR/ignore" ]; then
    git config --global core.excludesfile "$GITCONFIG_DIR/ignore"
fi

if [ -f "$GITCONFIG_DIR/commit_message" ]; then
    git config --global commit.template "$GITCONFIG_DIR/commit_message"
fi

git config --global color.branch.current "yellow reverse"
git config --global color.branch.local "yellow"
git config --global color.branch.remote "green"
git config --global color.status.changed "yellow"
git config --global color.status.added "green"
git config --global color.status.untracked "red"
git config --global color.diff.meta "yellow bold"
git config --global color.diff.frag "magenta bold"
git config --global color.diff.old "red"
git config --global color.diff.new "green"

# Branch Aliases
git config --global alias.branch-name "rev-parse --abbrev-ref HEAD"
git config --global alias.new-branch "checkout -b"

# other aliases
git config --global alias.ls "status -s"
git config --global alias.fix "commit -a --amend --no-edit"

if check_for_command fzf; then
    git_list_files="git ls-files --modified --exclude-standard"
    fzf_flags="-m --ansi --preview \"git diff \$@ --color=always -- {-1}\")"
    git config --global alias.ia "!git add \$($git_list_files | fzf $fzf_flags"
fi

# Save password
if is_mac; then
    git config --global credential.helper osxkeychain
else
    git config --global credential.helper cache
fi

if [ -f "$HOME/.gitconfig" ]; then
    mkdir -p "$GITCONFIG_DIR"
    mv "$HOME/.gitconfig" "$GITCONFIG_DIR/config"
fi

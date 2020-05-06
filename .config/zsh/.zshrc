# ---------------------------------------------------------------------------------------
# ---{ My .zshrc } ----------------------------------------------------------------------
# ---------------------------------------------------------------------------------------
#
#   When you start an interactive zsh, it reads ~/.zshrc. This is a good place for
#   contains things that must be done for every shell instance, such as alias and
#   function definitions, shell option settings, completion settings, prompt settings,
#   key bindings, etc.
#

PLATFORM='unknown'
case "$(uname)" in
    "Darwin") PLATFORM='osx';;
    "Linux") PLATFORM='linux';;
    "FreeBSD") PLATFORM='freebsd';;
    *);;
esac

is_mac(){
    [ "$PLATFORM" = "osx" ]
}

is_linux(){
    [ "$PLATFORM" = "linux" ]
}

is_freebsd(){
    [ "$PLATFORM" = "freebsd" ]
}
is_windows(){
    grep -q Microsoft /proc/version
}

# ---{ Zinit }---------------------------------------------------------------------------
#
source "$HOME/.config/zsh/.zinit/bin/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Pure theme
zinit ice compile'(pure|async).zsh' pick'async.zsh' src'pure.zsh'
zinit light sindresorhus/pure

# Suggestions for zsh
zinit ice wait"0" silent atload"_zsh_autosuggest_start"
zinit light "zsh-users/zsh-autosuggestions"

zinit light "agkozak/zsh-z"

function _zinit_plugin_exists(){
	[ -e "$ZDOTDIR/.zinit/plugins/$1" ] > /dev/null
}


# ---{ zplug }---------------------------------------------------------------------------

source "$ZPLUG_HOME/init.zsh"

zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-completions"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

# ---{ Shell only programs }-------------------------------------------------------------

zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit light sharkdp/fd

zinit ice as"command" from"gh-r" mv"bat* -> bat" pick"bat/bat"
zinit light sharkdp/bat
if _zinit_plugin_exists "sharkdp---bat"
then alias cat='bat --paging=never --style=plain'
fi

zinit ice as"program" make'!' atclone'./direnv hook zsh > zhook.zsh' \
	atpull'%atclone' src"zhook.zsh"
zinit light direnv/direnv

zinit ice atclone'PYENV_ROOT="$PWD" ./libexec/pyenv init - > zpyenv.zsh' \
	atinit'export PYENV_ROOT="$PWD"' atpull"%atclone" \
	as'command' pick'bin/pyenv' src"zpyenv.zsh" nocompile'!'
zinit light pyenv/pyenv

zinit ice atclone'NODENV_ROOT="$PWD" ./libexec/nodenv init - > znodenv.zsh' \
	atinit'export NODENV_ROOT="$PWD"' atpull"%atclone" \
	as'command' pick'bin/nodenv' src"znodenv.zsh" nocompile'!'
zinit light nodenv/nodenv

zinit ice wait"2" lucid as"program" pick"bin/git-dsf"
zinit load zdharma/zsh-diff-so-fancy
if check_for_command git && _zinit_plugin_exists "zdharma---zsh-diff-so-fancy"
then git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
fi

unset -f _zinit_plugin_exists

# ---{ Souce completions }---------------------------------------------------------------

function source_if_file(){ [[ -f $1 ]] && source $1 }
function source_if_possible(){ [[ -e $1 ]] && source $1 }
function check_for_command(){ command -v $1 >/dev/null 2>&1 }

if check_for_command brew
then FPATH="/usr/local/share/zsh/site-functions":$FPATH
fi

source_if_possible "/usr/local/share/zsh/site-functions"

# Updates PATH for the Google Cloud SDK.
# and enables shell command completion for gcloud.
source_if_file "$GCLOUD_HOME/path.zsh.inc"
source_if_file "$GCLOUD_HOME/completion.zsh.inc"

if check_for_command kubectl
then source <(kubectl completion zsh)
fi


# ---{ Aliases }-------------------------------------------------------------------------

source_if_file "$ZDOTDIR/aliases.sh"

# Alias things quickly and worry about it later.
# https://news.ycombinator.com/item?id=9869231
function save() {
	echo "alias $1='${@:2}'" >> "$ZDOTDIR/aliases.sh"
	echo "made alias:"
	echo "alias $1='${@:2}'"
	source "$ZDOTDIR/aliases.sh"
}

# ---{ Path Utils }----------------------------------------------------------------------

function prune_path(){
	PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
	export PATH
}

function add_path(){
	echo "PATH_append $1" >> "$HOME/.zshenv"
}

function grep-path(){
	echo -e ${PATH//:/\\n} | rg $1
}

# ---{ rsync Functions }-----------------------------------------------------------------

function copy_to_cdf(){
	rsync -avz uoftcs:~/$1 $(pwd)
}


function copy_from_cdf(){
	rsync -avzh uoftcs:~/$1 $(pwd)
}

# ---{ Other Functions }-----------------------------------------------------------------

function mkcd () {
	mkdir -p $1
	cd $1
}

function bak(){
	cp $1{,.bak}
}

function overview(){
	files_to_ignore=".git|node_modules|bower_components|.DS_Store"
	tree -aC -I $files_to_ignore --dirsfirst "$@"
}

function grep-history(){
	history | grep $1
}

function grep-node(){
	node_apps_to_ignore="Visual|Insomnia|Typhora|Postman|Keybase|Notion||Uebersicht|Slack"
	ps aux \
		| grep -i node \
		| grep -v $node_apps_to_ignore
}

function kill-program(){
	ps -ef | fzf | awk '{print $2}' | xargs kill -9
}

function kill-node(){
	grep-node $1 | fzf | xargs kill -9
}

function merge-pdf () {
	gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$1" "${@:2}"
}

function vwiki(){
	rg --files "$1" "/Volumes/vikram/Dropbox/notebook" | fzf | xargs nvim
}

# Extract many types of compressed packages
# Credit: http://nparikh.org/notes/zshrc.txt
function extract() {
	if [ -f "$1" ]
	then
		case "$1" in
			*.tar.bz2)  tar -jxvf "$1"                               ;;
			*.tar.gz)   tar -zxvf "$1"                               ;;
			*.bz2)      bunzip2 "$1"                                 ;;
			*.dmg)      hdiutil mount "$1"                           ;;
			*.gz)       gunzip "$1"                                  ;;
			*.tar)      tar -xvf "$1"                                ;;
			*.tbz2)     tar -jxvf "$1"                               ;;
			*.tgz)      tar -zxvf "$1"                               ;;
			*.zip)      unzip "$1"                                   ;;
			*.ZIP)      unzip "$1"                                   ;;
			*.pax)      cat "$1" | pax -r                            ;;
			*.pax.Z)    uncompress "$1" --stdout | pax -r            ;;
			*.Z)        uncompress "$1"                              ;;
			*) echo "'$1' cannot be extracted/mounted via extract()" ;;
		esac
	else
		echo "'$1' is not a valid file to extract"
	fi
}

GPG_PUBLIC_ID="4EEDCD431B31F8D1"
if check_for_command gpg
then
    git config --global gpg.program gpg
    git config --global commit.gpgsign false
    git config --global user.signingkey "$GPG_PUBLIC_ID"
fi

# ---{ hooks }---------------------------------------------------------------------------

# pipx competions
if check_for_command pipx
then eval "$(register-python-argcomplete pipx)"
fi

if check_for_command jenv
then eval "$(jenv init -)"
fi

# ---------------------------------------------------------------------------------------

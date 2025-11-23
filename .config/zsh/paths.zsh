#!/bin/zsh
#


# Utility: Append a directory to PATH only if it's not already present
PATH_append() {
    case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}

prune_path() {
    export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
}

add_path() {
    echo "PATH_append $1" >> "$XDG_CONFIG_HOME/zsh/.zshenv"
}

grep_path() {
    echo -e ${PATH//:/\\n} | rg $1
}

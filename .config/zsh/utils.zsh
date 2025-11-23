# ---{ Utility Functions }---------------------------------------------------------------

# Check if a command exists
check_for_command() {
    command -v "$1" >/dev/null 2>&1
}

# Make directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Backup a file
bak() {
    cp "$1"{,.bak}
}

overview() {
    tree -aC -I ".git|node_modules|bower_components|.DS_Store|repo.git" --dirsfirst "$@"
}

# ---{ Ripgrep-based functions }--------------------------------------------------------

# Search shell history
grep_history() {
    history | rg --no-heading --color=always "$1"
}

# List node processes, excluding unwanted apps
grep_node() {
    ps aux \
        | rg -i 'node' \
        | rg -v 'Visual|Insomnia|Typhora|Postman|Notion|Uebersicht|Slack'
}

# Fuzzy-kill any process
kill_program() {
    ps -ef \
        | fzf \
        | awk '{print $2}' \
        | xargs kill -9
}

# Fuzzy-kill node-related processes
kill_node() {
    grep_node \
        | fzf \
        | awk '{print $2}' \
        | xargs kill -9
}

# Merge PDFs
merge_pdf() {
    gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile="$1" "${@:2}"
}

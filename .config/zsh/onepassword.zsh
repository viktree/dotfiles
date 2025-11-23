#!/bin/zsh
#
# opdev - 1Password DevSecrets helper

unalias opdev 2>/dev/null

VAULT_NAME="DevSecrets"

# -------------------------------
# Private helpers
# -------------------------------
_opdev() {
  # Wrap op CLI to automatically use DevSecrets vault
  if [[ "$1" == "read" || "$1" == "item" ]]; then
    op "$1" --vault "${VAULT_NAME}" "${@:2}"
  else
    op "$@"
  fi
}

_set_secret() {
  local key_name="$1"
  local key_value="$2"

  if _opdev item list | grep -q "$key_name"; then
    echo "Updating existing API key: $key_name"
    _opdev item edit "$key_name" "password=$key_value"
  else
    echo "Creating new API key: $key_name"
    _opdev item create \
      --title "$key_name" \
      --category "password" \
      password="$key_value"
  fi
}

_get_secret() {
  local key_name="$1"
  _opdev item get "$key_name" --field password
}

_export_secret() {
  local key_name="$1"
  local verbose="$2"

  export "$key_name"="$(_get_secret "$key_name")"

  if [[ "$verbose" == "verbose" ]]; then
    echo "Exported $key_name to environment"
  fi
}

# -------------------------------
# Public CLI interface
# -------------------------------
opdev() {
  local cmd="$1"
  shift

  case "$cmd" in
    set)
      if [[ $# -ne 2 ]]; then
        echo "Usage: opdev set <KEY_NAME> <VALUE>"
        return 1
      fi
      _set_secret "$1" "$2"
      ;;
    get)
      if [[ $# -ne 1 ]]; then
        echo "Usage: opdev get <KEY_NAME>"
        return 1
      fi
      _get_secret "$1"
      ;;
    export)
      if [[ $# -ne 1 ]]; then
        echo "Usage: opdev export <KEY_NAME>"
        return 1
      fi
      _export_secret "$1"
      ;;
    *)
      echo "Usage: opdev <set|get|export> ..."
      return 1
      ;;
  esac
}

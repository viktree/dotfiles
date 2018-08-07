#!/bin/sh

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='code'
else
  export EDITOR='nvim'
fi

case "$platform" in
    "osx")
        # Set all Hombrew apps to correct location.
        export HOMEBREW_CASK_OPTS="--appdir=/Applications"
        ;;
    "linux")
        ;;
    "freebsd")
        ;;
    *)
        ;;
esac

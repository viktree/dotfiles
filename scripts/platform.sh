#!/bin/sh

platform='unknown'
unamestr="$(uname)"

case "$unamestr" in
    "Darwin")
        platform='osx'
        ;;
    "Linux")
        platform='linux'
        ;;
    "FreeBSD")
        platform='freebsd'
        ;;
    *)
        ;;
esac

export $platform
#!/bin/bash

ARCH=`arch`

if [[ "${ARCH}"  == "arm64" ]]; then
    export BREW_BIN="/opt/homebrew/bin/brew"
else
    export BREW_BIN="/usr/local/bin/brew"
fi

echo $BREW_BIN

$BREW_BIN $*


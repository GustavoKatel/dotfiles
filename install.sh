#!/usr/bin/env bash

# set -x
set -e

DOTFILES_DIR=$(dirname $0)

$DOTFILES_DIR/sync.sh -o install $*
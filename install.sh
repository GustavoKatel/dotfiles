#!/usr/bin/env bash

# set -x
set -e

DOTFILES_DIR=$(dirname $0)

cd $DOTFILES_DIR

stow -v .

#!/bin/bash

# based on https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-windowizer

current_folder=$PWD

selected=$(find $current_folder -mindepth 1 -maxdepth 1 -type d | fzf)

if [[ -z $selected ]]; then
    exit 0
fi

tmux neww -c $selected

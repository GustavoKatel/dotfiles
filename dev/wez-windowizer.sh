#!/bin/bash

# based on https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer

selected=$(find ~/dev ~/dev/runlet ~/dev/toggl -mindepth 0 -maxdepth 2 -type d | fzf)

if [[ -z $selected ]]; then
    exit 0
fi

selected_name=$(basename "$selected" | tr . _)

wezterm cli spawn --cwd $selected

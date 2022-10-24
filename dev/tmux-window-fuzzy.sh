#!/bin/bash

tmux select-window -t $(tmux list-windows -F '#I: #W' | fzf | awk '{ print substr($1, 0, length($1)-1) }')

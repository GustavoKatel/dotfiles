#!/bin/bash

tmux select-window -t $(tmux list-windows -F '#I: #W (#S)' $* | fzf | awk '{ print substr($1, 0, length($1)-1) }')

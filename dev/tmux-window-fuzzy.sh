#!/bin/bash

function select_session_and_window() {
    session=$(echo $* | awk '{ print substr($4, 2, length($4)-2) }')
    tmux switch-client -t $session

    window=$(echo $* | awk '{ print substr($1, 0, length($1)-1) }')
    tmux select-window -t $window
}

output=$(tmux list-windows -F '#I: #W (#S)' $* | fzf)

select_session_and_window $output

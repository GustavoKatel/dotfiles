#!/bin/bash

export SHELL_RECURSIVE_COUNTER=$((${SHELL_RECURSIVE_COUNTER:-0}+1))

function shell_counter() {

  ignore_value=0
  if [ -n "$TMUX" ]; then
      # tmux adds one extra session
      # starship adds one extra session too
      ignore_value=2
  fi

  counter=$(($SHELL_RECURSIVE_COUNTER-$ignore_value))

  test $counter -le 1 && exit 1;

  echo $counter
}
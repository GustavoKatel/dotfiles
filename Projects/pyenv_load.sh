#!/bin/bash

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PYENV_VERSION=3.7.9
eval "$(pyenv init -)"

command=$SHELL

if [ "$#" -gt "0" ]; then
    command=$*
fi

$command


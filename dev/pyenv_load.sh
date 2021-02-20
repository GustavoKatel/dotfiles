#!/bin/bash

ARCH=`arch`

if [[ "${ARCH}"  == "arm64" ]]; then
    unset PYENV_VERSION
else
    # rosetta should run python 3.7.9
    export PYENV_VERSION=3.7.9
fi



source $HOME/dev/apple_silicon_shims/pyenv_silicon.sh

command=$SHELL

if [ "$#" -gt "0" ]; then
    command=$*
fi

$command


#!/bin/bash

export ROSETTA_SHELL=true

if [ "$#" -gt 0 ]; then
    arch -x86_64 $SHELL -c "$*"
else
    arch -x86_64 $SHELL
fi


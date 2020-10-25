#!/bin/bash

export LANG=en_US.UTF-8
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8
export TERM=xterm-256color
export SHELL=bash

cd /workspace && nohup nvim --listen 0.0.0.0:7777 --headless > /tmp/nvim.log 2>/tmp/nvim.err.log &

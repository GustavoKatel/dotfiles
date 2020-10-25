#!/bin/bash

cd /workspace && nohup nvim --listen 0.0.0.0:7777 --headless > /tmp/nvim.log 2>/tmp/nvim.err.log &

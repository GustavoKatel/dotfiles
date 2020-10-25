#!/bin/bash

set -e
set -x

export DEBIAN_FRONTEND=noninteractive

apt update

apt upgrade -y

apt install -y git ripgrep fzf nodejs python3 python3-pip

pip3 install pynvim

wget https://github.com/neovim/neovim/releases/download/v0.4.4/nvim-linux64.tar.gz -O /tmp/nvim.tar.gz

cd /tmp

tar xvf nvim.tar.gz

cp -r nvim-linux64 /opt/nvim

ln -s /opt/nvim/bin/nvim /usr/bin/nvim

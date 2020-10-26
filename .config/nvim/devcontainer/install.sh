#!/bin/bash

set -e
set -x

export DEBIAN_FRONTEND=noninteractive

apt update

apt upgrade -y

########## install deps
apt install -y git ripgrep nodejs npm python3 python3-pip locales locales-all

pip3 install pynvim neovim-remote
npm install -g neovim

######### install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

######## setup locale
echo "LC_ALL=en_US.UTF-8" >> /etc/environment
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
locale-gen en_US.UTF-8

############ install neovim
wget https://github.com/neovim/neovim/releases/download/v0.4.4/nvim-linux64.tar.gz -O /tmp/nvim.tar.gz

cd /tmp

tar xvf nvim.tar.gz

cp -r nvim-linux64 /opt/nvim

ln -s /opt/nvim/bin/nvim /usr/bin/nvim

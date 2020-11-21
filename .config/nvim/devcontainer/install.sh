#!/bin/bash

set -e
set -x

export DEBIAN_FRONTEND=noninteractive

apt update

apt upgrade -y

########## install deps
apt install -y git ripgrep python3 python3-pip locales locales-all ranger

curl https://deb.nodesource.com/setup_14.x | bash

apt update && apt install -y nodejs

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
NVIM_URL=https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz

wget $NVIM_URL -O /tmp/nvim.tar.gz

cd /tmp

tar xvf nvim.tar.gz

cp -r nvim-linux64 /opt/nvim

ln -s /opt/nvim/bin/nvim /usr/bin/nvim

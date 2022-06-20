#!/usr/bin/env bash

# set -x
set -e

DOTFILES_DIR=$(readlink -f $(dirname $0) )
TARGET=~

exec="run"

OPERATION=""

UPLOAD=false

function usage() {
    echo "$0 -o install|backup [-d] [-u]"
    echo "-o OPERATION can be install or backup"
    echo "-d run in dry run mode"
    echo "-u upload to github"
}

# list of arguments expected in the input
optstring=":duo:"

while getopts ${optstring} arg; do
  case ${arg} in
    d)
        echo "Running in dry run mode!"
        exec="echo"
    ;;
    o)
        OPERATION=${OPTARG}
        echo $OPERATION
    ;;
    u)
        UPLOAD=true
    ;;
    ?)
        echo "Invalid option: -${OPTARG}."
        usage
        exit 2
    ;;
  esac
done

IS_INSTALL=false
if [ "$OPERATION" = "install" ]; then
    IS_INSTALL=true
fi

IS_BACKUP=false
if [ "$OPERATION" = "backup" ]; then
    IS_BACKUP=true
fi

function invalid_operation() {
    echo "Invalid operation!"
    usage
    exit 1
}

$IS_INSTALL || $IS_BACKUP || invalid_operation

function run() {
    echo -n "* [.] $*"
    $*
    status="OK"
    if [ "$?" != "0" ]; then
        status="FAIL ($?)"
    fi
    echo -e "\r* [$status] $*"
}

function upload() {
    cd $DOTFILES_DIR
    git add .
    git commit -am "$(TZ=":America/Los_Angeles" date)"
    git push
}

# ---------------------------
# .config
$IS_INSTALL && $exec mkdir -p $TARGET/.config/

for file in $(ls $DOTFILES_DIR/.config/); do
    $IS_INSTALL && $exec rm -rf $TARGET/.config/$file
    $IS_INSTALL && $exec ln -s $DOTFILES_DIR/.config/$file $TARGET/.config/$file
done

# ---------------------------
# oh-my-zsh (deprecated)
# $exec cp -r $DOTFILES_DIR/.oh-my-zsh/* $TARGET/.oh-my-zsh/

# ---------------------------
# standalone files
rc_files=( .tmux.conf .vimrc .zshrc .custom.zsh .tmux)

for file in "${rc_files[@]}"; do
    $IS_INSTALL && $exec rm -rf $TARGET/$file
    $IS_INSTALL && $exec ln -s $DOTFILES_DIR/$file $TARGET/$file
done

# ---------------------------
# misc
$IS_INSTALL && $exec mkdir -p $TARGET/dev
for file in $(ls $DOTFILES_DIR/dev); do
    name=$(basename $file)
    source_file_name=$DOTFILES_DIR/dev/$file
    target_file_name=$TARGET/dev/$name
    $IS_INSTALL && $exec rm -f $target_file_name
    $IS_INSTALL && $exec ln -s $source_file_name $target_file_name
done

# ----------------- upload

$IS_BACKUP && $UPLOAD && upload

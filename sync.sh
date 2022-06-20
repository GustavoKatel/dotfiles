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
        exec="echo [dry-run]"
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

# check if file exists in `dotfiles`
# if not copy from target to `dotfiles` and convert to a link
function auto_back_link() {
    source_file_name=$1
    target_file_name=$2
    if [[ -e $target_file_name && ! -e $source_file_name ]]; then

        if [[ -L $target_file_name ]]; then
            echo "Target is already a symlink! Aborting... $target_file_name"
            exit 1
        fi

        $exec cp -r $target_file_name $source_file_name
        $exec rm -rf $target_file_name
        $exec ln -s $source_file_name $target_file_name
    fi
}

function auto_install_link() {
    source_file_name=$1
    target_file_name=$2

    $exec rm -rf $target_file_name
    $exec ln -s $source_file_name $target_file_name
}

# ---------------------------
# .config
$IS_INSTALL && $exec mkdir -p $TARGET/.config/

for file in $(ls $DOTFILES_DIR/.config/); do
    $IS_INSTALL && auto_install_link $DOTFILES_DIR/.config/$file $TARGET/.config/$file

    $IS_BACKUP && auto_back_link $DOTFILES_DIR/.config/$file $TARGET/.config/$file
done

# ---------------------------
# oh-my-zsh (deprecated)
# $exec cp -r $DOTFILES_DIR/.oh-my-zsh/* $TARGET/.oh-my-zsh/

# ---------------------------
# standalone files
rc_files=( .tmux.conf .vimrc .zshrc .custom.zsh .tmux)

for file in "${rc_files[@]}"; do
    $IS_INSTALL && auto_install_link $DOTFILES_DIR/$file $TARGET/$file

    $IS_BACKUP && auto_back_link $DOTFILES_DIR/$file $TARGET/$file
done

# ---------------------------
# misc
$IS_INSTALL && $exec mkdir -p $TARGET/dev
for file in $(ls $DOTFILES_DIR/dev); do
    source_file_name=$DOTFILES_DIR/dev/$file
    target_file_name=$TARGET/dev/$file
    $IS_INSTALL && auto_install_link $source_file_name $target_file_name

    $IS_BACKUP && auto_back_link $source_file_name $target_file_name
done

# ----------------- upload

$IS_BACKUP && $UPLOAD && upload

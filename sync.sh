#!/usr/bin/env bash

# set -x
set -e

DOTFILES_DIR=$(dirname $(realpath $0))
TARGET=~

exec="run"

OPERATION=""

function usage() {
    echo "$0 -o install|backup [-d]"
    echo "-o OPERATION can be install or backup"
    echo "-d run in dry run mode"
}

# list of arguments expected in the input
optstring=":do:"

while getopts ${optstring} arg; do
  case ${arg} in
    d)
        echo "Running in dry run mode!"
        exec="echo"
    ;;
    o)
        OPERATION=${OPTARG}
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

# ---------------------------
# .config
$IS_INSTALL && $exec cp -r $DOTFILES_DIR/.config/* $TARGET/.config/
$IS_BACKUP  && $exec cp -r $TARGET/.config/{awesome,rofi,starship.toml} $DOTFILES_DIR/.config/

# ---------------------------
# oh-my-zsh (deprecated)
# $exec cp -r $DOTFILES_DIR/.oh-my-zsh/* $TARGET/.oh-my-zsh/

# ---------------------------
# standalone files
rc_files=( .hyper.js .tmux.conf .vimrc .zshrc )

for file in "${rc_files[@]}"; do
    $IS_INSTALL && $exec cp $DOTFILES_DIR/$file $TARGET
    $IS_BACKUP  && $exec cp $TARGET/$file $DOTFILES_DIR/
done

# ---------------------------
# sym links
for file in $(ls $DOTFILES_DIR/Projects); do
    name=$(basename $file)
    source_file_name=$DOTFILES_DIR/Projects/$file
    target_file_name=$TARGET/Projects/$name
    $IS_INSTALL && (test -e $target_file_name || $exec ln -fs $source_file_name $target_file_name)
done

# ---------------------------
# .argos (deprecated)
# $exec cp -r $DOTFILES_DIR/argos $TARGET/argos
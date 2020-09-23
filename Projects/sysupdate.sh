#!/usr/bin/env bash

set -e
set -x

yay -Suy

if [ "$1" != "--all" ]; then
    exit 0
fi

flatpak update

rustup update

CARGO_BINS=(exa)

for bin in "${CARGO_BINS[@]}"; do
    cargo install $bin
done
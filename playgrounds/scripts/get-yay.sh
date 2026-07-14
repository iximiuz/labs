#!/bin/sh
set -eu

DIR=$(mktemp -d)

git clone --depth 1 https://aur.archlinux.org/yay-bin.git "${DIR}/yay"

cd "${DIR}/yay"
makepkg -si --noconfirm
cd /

rm -rf "${DIR}"

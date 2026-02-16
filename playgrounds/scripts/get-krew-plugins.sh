#!/bin/sh
set -eu

krew install krew
echo '' >> $HOME/.bashrc
echo 'export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"' >> $HOME/.bashrc

# Pre-install some plugins
krew install neat
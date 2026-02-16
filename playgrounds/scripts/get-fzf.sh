#!/bin/sh
set -eu

git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
$HOME/.fzf/install

git clone --depth 1 https://github.com/junegunn/fzf.vim.git $HOME/.vim/bundle/fzf.vim

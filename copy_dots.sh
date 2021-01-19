#!/usr/bin/env bash

SHELLRC="${HOME}/.zshrc"
PROFILE="${HOME}/.zprofile"
NVIMRC="${HOME}/.vimrc" # Recall, I symlinked this to init.vim
INITVIM="/Users/johnmarkham/.config/nvim/init.vim" # Recall, I symlinked this to init.vim

cp "$SHELLRC" "$PWD" &>/dev/null
cp "$NVIMRC" "$PWD" &>/dev/null 
cp "$INITVIM" "$PWD" &>/dev/null 
cp "$PROFILE" "$PWD" &>/dev/null

#!/usr/bin/env bash

SHELLRC="${HOME}/.zshrc"
PROFILE="${HOME}/.zprofile"
NVIMRC="${HOME}/.vimrc" # Recall, I symlinked this to init.vim

cp "$SHELLRC" "$PWD"
cp "$NVIMRC" "$PWD"
cp "$PROFILE" "$PWD"


# One more and I'll go loop

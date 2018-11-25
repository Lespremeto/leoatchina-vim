#!/usr/bin/env sh
warn() {
    echo "$1" >&2
}

die() {
    warn "$1"
    exit 1
}

rm $HOME/.vimrc
rm $HOME/.vimrc.plugs
rm $HOME/.vimrc.clean
rm $HOME/.vimrc.update
rm $HOME/.vimrc.md


rm -rf $HOME/.vim
rm -rf $HOME/.mvim
rm -rf $HOME/.nvim
rm -rf $HOME/.gvim
rm -rf $HOME/.vim-plug

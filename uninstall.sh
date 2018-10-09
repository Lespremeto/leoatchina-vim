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
if [ -f $HOME/.config/nvim/init.vim ];then
    rm $HOME/.config/nvim/init.vim
fi

rm -rf $HOME/.vim
rm -rf $HOME/.gvim
rm -rf $HOME/.nvim
if [ -d $HOME/.local/share/nvim ];then
    rm -rf $HOME/.local/share/nvim
fi

#!/bin/bash

#Git the newest version of the dotfiles
if [ ! -d ~/.dotconf ]; then
    git clone --recursive https://github.com/dvanallen/dotconf.git ~/.dotconf
else
    git --git-dir=$HOME/.dotconf/.git/ --work-tree=$HOME/.dotconf pull --ff-only --recurse-submodules=on-demand
fi

#Make a backup of existing dotconf files and copy over the new ones.
BACKUP_DIR=~/.dotbackup/$(date +%y%m%d%H%M%S)
mkdir -p $BACKUP_DIR
for file in ~/.dotconf/.[^.]*; do
    #Use greedy glob removal to grab the basename of each dotfile.
    BASENAME=${file##*/}
    mv ~/$BASENAME $BACKUP_DIR/$BASENAME
    cp -r ~/.dotconf/$BASENAME ~/$BASENAME
done

echo "Don't forget to source the shell profile!"

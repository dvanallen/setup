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
    if [ $BASENAME != ".git" ] && [ $BASENAME != ".gitmodules" ]; then
        if [ -e ~/$BASENAME ]; then
            cp -r ~/$BASENAME $BACKUP_DIR/$BASENAME
        fi
        if [ -d ~/$BASENAME ]; then
            cp -r ~/.dotconf/$BASENAME/. ~/$BASENAME
        else
            cp -r ~/.dotconf/$BASENAME ~/$BASENAME
        fi
    fi
done

#Fix SSH directory permissions
chmod 700 ~/.ssh
chmod -R 600 ~/.ssh/*

if [ "$(uname -s)" = Darwin ]; then
	if ! which -s brew; then
		echo "Installing homebrew"
		ruby -e "$(curl -fsSL https://raw.github.com/mxcl/homebrew/go)"
		PATH=$PATH:/usr/local/bin
	fi
	brew install cmake git tmux vim macvim mobile-shell openssh openssl nmap bash coreutils node
fi

#Vim setup
mkdir ~/.vim/autoload && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle/YouCompleteMe
./install.sh --clang-completer
cd ~/.vim/bundle/tern_for_vim
npm install

echo "Don't forget to source the shell profile!"

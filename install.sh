#!/usr/bin/env bash

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
FILES=".ackrc .editrc .gitconfig .hushlogin .inputrc .irbrc .screenrc .tmux.conf .vim .vimrc .zshrc"
for FILE in $FILES; do
	ln -sf "$DIR/$FILE" "$HOME/$FILE"
done

#!/usr/bin/env bash

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
FILES=".editrc .gitconfig .hushlogin .inputrc .irbrc .tmux.conf .vim .vimrc .zshrc"
for FILE in $FILES; do
	ln -sf "$DIR/$FILE" "$HOME/$FILE"
done

mkdir -p "$HOME/.config/fish"
ln -sf "$DIR/alacritty.yml" "$HOME/.config/alacritty.yml"
ln -sf "$DIR/config.fish" "$HOME/.config/fish/config.fish"

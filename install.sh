#!/usr/bin/env bash

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

read -p "Git User Email: " gitemail
cat > "/tmp/.gitconfig" <<EOF
[user]
	name = Jeremy Larkin
	email = $gitemail

[include]
	path = $DIR/.gitconfig
EOF

mv /tmp/.gitconfig "$HOME/.gitconfig"

FILES=".editrc .hushlogin .inputrc .irbrc .tmux.conf .vim .vimrc .zsh .zshrc"
for FILE in $FILES; do
	ln -sf "$DIR/$FILE" "$HOME/$FILE"
done

mkdir -p "$HOME/.config/fish"
ln -sf "$DIR/alacritty.yml" "$HOME/.config/alacritty.yml"
ln -sf "$DIR/config.fish" "$HOME/.config/fish/config.fish"

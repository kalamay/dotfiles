#!/usr/bin/env bash

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

read -p "Git User Email: " git_email
cat > "$HOME/.gitconfig" <<EOF
[user]
	name = Jeremy Larkin
	email = $git_email

[include]
	path = $DIR/.gitconfig
EOF

mkdir -p "$HOME/opt/bin"
for FILE in $(ls $DIR/bin); do
	ln -sf "$DIR/bin/$FILE" "$HOME/opt/bin/$FILE"
done

FILES=".editrc .hushlogin .inputrc .irbrc .tmux.conf .vim .vimrc .zsh .zshrc .gitignore_global"
for FILE in $FILES; do
	ln -sf "$DIR/$FILE" "$HOME/$FILE"
done

mkdir -p "$HOME/.config/fish"
ln -sf "$DIR/alacritty.yml" "$HOME/.config/alacritty.yml"
ln -sf "$DIR/config.fish" "$HOME/.config/fish/config.fish"

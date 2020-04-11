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
	rm -f "$HOME/$FILE"
	ln -s "$DIR/$FILE" "$HOME/$FILE"
done

mkdir -p "$HOME/.config/fish"
for FILE in $(ls $DIR/fish); do
	rm -f "$HOME/.config/fish/$FILE"
	ln -s "$DIR/fish/$FILE" "$HOME/.config/fish/$FILE"
done

rm -f "$HOME/.config/alacritty.yml"
ln -s "$DIR/alacritty.yml" "$HOME/.config/alacritty.yml"
tic "$DIR/xterm-256color.terminfo"

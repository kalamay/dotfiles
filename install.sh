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

HOME_FILES=".editrc .hushlogin .inputrc .irbrc .tmux.conf .zsh .zshrc .gitignore_global"
for FILE in $HOME_FILES; do
	rm -f "$HOME/$FILE"
	ln -s "$DIR/$FILE" "$HOME/$FILE"
done

mkdir -p "$HOME/.config"
for FILE in $(ls $DIR/config); do
	rm -f "$HOME/.config/$FILE"
	ln -s "$DIR/config/$FILE" "$HOME/.config/$FILE"
done

PAQ_PATH="$HOME/.local/share/nvim/site/pack/paqs/opt/paq-nvim" 
if [[ ! -d "$PAQ_PATH" ]]; then
	git clone https://github.com/savq/paq-nvim.git "$PAQ_PATH"
fi

theme

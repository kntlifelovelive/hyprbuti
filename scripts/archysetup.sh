#!/bin/bash

set -e

REPO="$HOME/hyprbuti/config"
CONFIG="$HOME/.config"
DATE="$(date +%Y%m%d_%H%M%S)"

mkdir -p "$CONFIG"

echo "Hypr Configurations Setup from $REPO"
echo

# Skip list (Pro Style)
SKIP_ITEMS=("mainstaller" "packages" "scripts" "photo")

for item in "$REPO"/*; do
	[ -e "$item" ] || continue
	name="$(basename "$item")"

	# Check skip list
	for skip in "${SKIP_ITEMS[@]}"; do
		if [[ "$name" == "$skip" ]]; then
			echo "Skipping $name"
			continue 2
		fi
	done

	# Special case for bash folder
	if [[ "$name" == "zsh" ]]; then
		if [ -f "$item/.zshrc" ]; then
			if [ -f "$HOME/.zshrc" ]; then
				echo "Backing up .zshrc → .zshrc_backup_$DATE"
				mv "$HOME/.zshrc" "$HOME/.zshrc_backup_$DATE"
			fi

			echo "Copying .zshrc to HOME"
			cp "$item/.zshrc" "$HOME/"
		fi
		continue
	fi

	# Normal config copy
	if [ -e "$CONFIG/$name" ]; then
		echo "Backing up $name → ${name}_backup_$DATE"
		mv "$CONFIG/$name" "$CONFIG/${name}_backup_$DATE"
	fi

	echo "Copying $name"
	cp -r "$item" "$CONFIG/"
done

echo
echo "Done "

#!/bin/bash

set -e

REPO="$HOME/hyprbuti/config"
CONFIG="$HOME/.config"
DATE="$(date +%Y%m%d_%H%M%S)"

mkdir -p "$CONFIG"

echo "Hypr Configurations Setup from $REPO"
echo

# Skip list (Pro Style)
SKIP_ITEMS=("mainstaller" "packages" "scripts")

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
	if [[ "$name" == "bash" ]]; then
		if [ -f "$item/.bashrc" ]; then
			if [ -f "$HOME/.bashrc" ]; then
				echo "Backing up .bashrc → .bashrc_backup_$DATE"
				mv "$HOME/.bashrc" "$HOME/.bashrc_backup_$DATE"
			fi

			echo "Copying .bashrc to HOME"
			cp "$item/.bashrc" "$HOME/"
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
echo "Done ✅"

#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_LIST="$SCRIPT_DIR/../packages/pkgslist.txt"

[[ ! -f "$PKG_LIST" ]] && {
	echo "Package list not found!"
	exit 1
}

for pkg in $(grep -vE '^\s*#|^\s*$' "$PKG_LIST"); do

	if pacman -Qi "$pkg" &>/dev/null; then
		echo "✔ $pkg already installed — skipping"
		continue
	fi

	if pacman -Si "$pkg" &>/dev/null; then
		echo "Installing $pkg (pacman)"
		sudo pacman -S --noconfirm --needed "$pkg" || {
			echo "⚠ Failed — skipping"
			continue
		}
	else
		echo "Installing $pkg (AUR via yay)"
		yay -S --noconfirm --needed "$pkg" || {
			echo "⚠ Failed — skipping"
			continue
		}
	fi

done

echo "✅ All packages processed!"
exit 0

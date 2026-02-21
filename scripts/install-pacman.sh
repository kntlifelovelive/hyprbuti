#!/usr/bin/env bash

set -o pipefail # keep pipe error detection
set +e          # DO NOT exit on error

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_LIST="$SCRIPT_DIR/../packages/pkgslist-pacman.txt"

[[ -f "$PKG_LIST" ]] || {
	echo "Pacman package list not found!"
	exit 1
}

# Read packages (remove comments & empty lines)
mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$PKG_LIST")

if [[ ${#packages[@]} -eq 0 ]]; then
	echo "No pacman packages to install."
	exit 0
fi

echo "Installing pacman packages..."

for pkg in "${packages[@]}"; do
	echo "→ $pkg"
	sudo pacman -S --needed --noconfirm "$pkg" &&
		echo "✔ Installed" ||
		echo "⚠ Failed — skipping"
done

echo "Pacman installation complete."
exit 0

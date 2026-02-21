#!/usr/bin/env bash

set -o pipefail
set +e # fail continue

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_LIST="$SCRIPT_DIR/../packages/pkgslist-yay.txt"

[[ -f "$PKG_LIST" ]] || {
	echo "Yay package list not found!"
	exit 1
}

command -v yay >/dev/null 2>&1 || {
	echo "yay is not installed!"
	exit 1
}

# Read file → remove comments & empty lines
mapfile -t packages < <(grep -vE '^\s*#|^\s*$' "$PKG_LIST")

if [[ ${#packages[@]} -eq 0 ]]; then
	echo "No yay packages to install."
	exit 0
fi

echo "Installing AUR packages..."

for pkg in "${packages[@]}"; do
	echo "→ $pkg"
	yay -S --needed --noconfirm "$pkg" &&
		echo "✔ Installed" ||
		echo "⚠ Failed — skipping"
done

echo "Yay installation complete."
exit 0

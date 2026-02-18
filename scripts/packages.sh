#!/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PKG_LIST="$SCRIPT_DIR/../packages/pkgslist.txt"

echo "== System Update =="
sudo pacman -Syu --noconfirm

mkdir ~/Pictures

echo "JaKooLit Wallpaper-Bank Installing ...."

git clone https://github.com/JaKooLit/Wallpaper-Bank.git

mv Wallpaper-Bank ~/Pictures/wallpaper

echo "Wallpaper Done Setup ... Successfull !!! "

# -----------------------------
# Install yay if not installed
# -----------------------------
if ! command -v yay &>/dev/null; then
	echo "== Installing yay (AUR helper) =="

	sudo pacman -S --needed --noconfirm base-devel git

	cd /tmp
	git clone https://aur.archlinux.org/yay.git
	cd yay
	makepkg -si --noconfirm
	cd ..
	rm -rf yay
else
	echo "yay already installed ✔"
fi

echo
echo "== Installing Packages =="

while IFS= read -r pkg; do
	# Skip empty lines
	[[ -z "$pkg" ]] && continue

	# Skip comment lines
	[[ "$pkg" =~ ^#.*$ ]] && continue

	# Already installed?
	if pacman -Qi "$pkg" &>/dev/null; then
		echo "✔ $pkg already installed — skipping"
		continue
	fi

	# Official repo check
	if pacman -Si "$pkg" &>/dev/null; then
		echo "Installing $pkg (pacman)"
		sudo pacman -S --noconfirm "$pkg"
	else
		echo "Installing $pkg (AUR via yay)"
		yay -S --noconfirm "$pkg"
	fi

done <"$PKG_LIST"

echo
echo "✅ All packages processed!"

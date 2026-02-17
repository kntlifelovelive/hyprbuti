#!/usr/bin/env bash

# -------- Colors --------
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

PKG_FILE="packages/pkglist.txt"
AUR_FILE="packages/aurlist.txt"

# ----------------------------
# Progress Bar Function
# ----------------------------
progress_bar() {
	local progress=$1
	local total=$2
	local width=30

	local percent=$((progress * 100 / total))
	local filled=$((progress * width / total))
	local empty=$((width - filled))

	printf "\r${BLUE}["
	printf "%0.s█" $(seq 1 $filled)
	printf "%0.s░" $(seq 1 $empty)
	printf "] ${percent}%%${NC}"
}

# ----------------------------
# Update System
# ----------------------------
echo -e "${BLUE}Updating system...${NC}"
sudo pacman -Syu --noconfirm

echo -e "${BLUE}Installing base tools...${NC}"
sudo pacman -S --needed --noconfirm base-devel git

# ----------------------------
# Install yay if missing
# ----------------------------
if ! command -v yay &>/dev/null; then
	echo -e "${PURPLE}Installing yay...${NC}"
	cd /tmp || exit
	rm -rf yay
	git clone https://aur.archlinux.org/yay.git
	cd yay || exit
	makepkg -si --noconfirm
else
	echo -e "${GREEN}yay already installed ✔${NC}"
fi

# ----------------------------
# Install Function With Bar
# ----------------------------
install_with_bar() {
	local file=$1
	local installer=$2

	total=$(grep -v '^$' "$file" | wc -l)
	count=0

	while read -r pkg; do
		[ -z "$pkg" ] && continue

		count=$((count + 1))
		progress_bar "$count" "$total"

		if ! $installer -S --needed --noconfirm "$pkg" &>/dev/null; then
			echo -e "\n${RED}✘ Failed ${pkg} — skipping${NC}"
		fi

	done <"$file"

	echo -e "\n${GREEN}✔ Done installing from $(basename "$file")${NC}"
}

# ----------------------------
# Pacman Packages
# ----------------------------
if [ -f "$PKG_FILE" ]; then
	echo -e "${BLUE}Installing pacman packages...${NC}"
	install_with_bar "$PKG_FILE" "sudo pacman"
fi

# ----------------------------
# AUR Packages
# ----------------------------
if [ -f "$AUR_FILE" ]; then
	echo -e "${BLUE}Installing AUR packages...${NC}"
	install_with_bar "$AUR_FILE" "yay"
fi

echo -e "${GREEN}All packages processed! 🚀${NC}"

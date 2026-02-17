#!/usr/bin/env bash

# --NOTE:  == Error check code for bash shell
set -x

# Photo Path Directories
FG_DIR="$HOME/.config/hypr/hyprlockphotos/foregroundimage/"
# restore Photo .cache/hyprlock file create manul
HYPRLOCK_FG="$HOME/.cache/hyprlock_fg"

mkdir -p "$HOME/.cache"

menu() {
	find "$FG_DIR" -type f \( \
		-iname "*.png" -o \
		-iname "*.webp" \
		-iname "*.jpg" -o \
		-iname "*.jpeg" \
		\) | sort | while read -r img; do
		name="$(basename "$img")"
		printf "%s\x00icon\x1f%s\n" "$name" "$img"
	done
}

choice="$(menu | rofi \
	-show-icons \
	-i \
	-dmenu \
	-theme ~/.config/hypr/hyprlockphotos/hyprlockForeImages.rasi \
	-p LockScreenImage)"

[ -z "$choice" ] && exit 0

IMG="$(find "$FG_DIR" -type f -iname "$choice" -print -quit)"
[ -z "$IMG" ] && exit 0

ln -sf "$IMG" "$HYPRLOCK_FG"

if pgrep hyprlock >/dev/null; then
	pkill -USR1 hyprlock
fi

exit 0

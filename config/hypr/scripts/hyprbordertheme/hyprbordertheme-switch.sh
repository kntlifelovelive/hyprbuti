#!/bin/bash

THEME_DIR="$HOME/.config/hypr/hyprbordercolortheme/"
TARGET="$HOME/.config/hypr/hyprsubconfig/colors.conf"

themes=$(find "$THEME_DIR" -maxdepth 1 -type f -iname "*.conf" -printf "%f\n" | sort)

chosen=$(echo "$themes" | rofi -dmenu -i \
	-theme "$HOME/.config/rofi/hyprbordertheme/hyprbordertheme-switch.rasi" \
	-p "HyprBorder-Theme = ")

[ -z "$chosen" ] && exit 0

cp "$THEME_DIR/$chosen" "$TARGET"

hyprctl reload

notify-send "Hyprland Theme Switched" "$chosen"

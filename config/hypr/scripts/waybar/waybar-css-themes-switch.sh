#!/usr/bin/env bash

WAYBAR="$HOME/.config/waybar"
CSS_DIR="$WAYBAR/themes"

THEME=$(ls "$CSS_DIR" | grep '\.css$' | wofi --dmenu -p "Waybar StyleCSS Theme")

[ -z "$THEME" ] && exit 0

# stop waybar
pkill waybar

# always restore base config
ln -sf "$WAYBAR/base/config.jsonc" "$WAYBAR/config.jsonc"

# switch css
ln -sf "$CSS_DIR/$THEME" "$WAYBAR/style.css"

# restart
waybar &
disown

notify-send "Waybar" "CSS Theme → $THEME"

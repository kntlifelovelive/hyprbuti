#!/usr/bin/env bash

WAYBAR="$HOME/.config/waybar"
PAIR_DIR="$WAYBAR/waybarthemepair"

THEME=$(ls "$PAIR_DIR" | wofi --dmenu -p "Waybar Theme Style Pair")

[ -z "$THEME" ] && exit 0

PAIR="$PAIR_DIR/$THEME"

# safety check
if [[ ! -f "$PAIR/config.jsonc" || ! -f "$PAIR/style.css" ]]; then
  notify-send "Waybar" "Invalid theme pair: $THEME"
  exit 1
fi

pkill waybar

ln -sf "$PAIR/config.jsonc" "$WAYBAR/config.jsonc"
ln -sf "$PAIR/style.css" "$WAYBAR/style.css"

waybar &
disown

notify-send "Waybar" "Theme Pair → $THEME"

#!/bin/env bash

ROFI_THEME="$HOME/.config/rofi/powermenu/powermenu.rasi"

options=" Poweroff
  Reboot
  Logout
 Lock"

chosen=$(echo -e "$options" | rofi -dmenu -theme "$ROFI_THEME" -lines 1 -p "SYSTEM")

case "$chosen" in
" Poweroff") systemctl poweroff ;;
" Reboot") systemctl reboot ;;
" Logout") hyprctl dispatch exit ;;
" Lock") loginctl lock-session ;;
esac

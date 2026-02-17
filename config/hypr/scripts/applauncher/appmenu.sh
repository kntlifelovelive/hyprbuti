#!/usr/bin/env bash

# Rofi App Menu Script
# -----------------------------------

ROFI_THEME="$HOME/.config/rofi/applauncher/applauncher.rasi"

rofi \
	-show drun \
	-theme "$ROFI_THEME" \
	-no-config \
	-disable-history \
	-click-to-exit

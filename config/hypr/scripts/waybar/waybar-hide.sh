#!/bin/bash

TOP_THRESHOLD=5 # px from top
HIDE_AFTER=50   # hide when cursor below this
CHECK_INTERVAL=0.15

VISIBLE=1 # 1 = visible, 0 = hidden

get_cursor_y() {
	hyprctl cursorpos | awk '{print $2}'
}

while true; do
	Y=$(get_cursor_y)

	# show bar (cursor at top)
	if [ "$Y" -le "$TOP_THRESHOLD" ] && [ "$VISIBLE" -eq 0 ]; then
		hyprctl dispatch setlayervisible waybar 1 >/dev/null 2>&1
		VISIBLE=1
	fi

	# hide bar (cursor moved down)
	if [ "$Y" -gt "$HIDE_AFTER" ] && [ "$VISIBLE" -eq 1 ]; then
		hyprctl dispatch setlayervisible waybar 0 >/dev/null 2>&1
		VISIBLE=0
	fi

	sleep $CHECK_INTERVAL
done

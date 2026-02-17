#!/bin/env bash

PERCENT=$(brightnessctl -m | cut -d, -f4 | tr -d '%')

BAR_LEN=20
FILLED=$((PERCENT * BAR_LEN / 100))
EMPTY=$((BAR_LEN - FILLED))

BAR="$(printf '█%.0s' $(seq 1 $FILLED))"
BAR+="$(printf '░%.0s' $(seq 1 $EMPTY))"

if [ "$PERCENT" -le 33 ]; then
	ICON="󰃞"
elif [ "$PERCENT" -le 66 ]; then
	ICON="󰃟"
else
	ICON="󰃠"
fi

echo "{\"text\":\"$ICON\",\"tooltip\":\"Brightness $PERCENT%\\n$ICON   $BAR\"}"

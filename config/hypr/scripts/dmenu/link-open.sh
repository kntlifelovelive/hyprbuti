#!/bin/sh

set -eu
BASE="$HOME/linkhub"
[ -d "$BASE" ] || exit 0

CATEGORY=$(ls "$BASE" | sed 's/.txt//' | dmenu -i -l 10 -p "Category:" \
	-nb "#1e1e2e" \
	-nf "#cdd6f4" \
	-sb "#89b4fa" \
	-sf "#1e1e2e")

[ -z "$CATEGORY" ] && exit 0

FILE="$BASE/$CATEGORY.txt"
[ -f "$FILE" ] || exit 0

LINK=$(cat "$FILE" | dmenu -i -l 20 -p "Open:" \
	-nb "#1e1e2e" \
	-nf "#cdd6f4" \
	-sb "#89b4fa" \
	-sf "#1e1e2e")

[ -z "$LINK" ] && exit 0

xdg-open "$LINK"

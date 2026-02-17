#!/bin/sh
set -eu

BASE="$HOME/linkhub"
mkdir -p "$BASE"

LINK=$(wl-paste)
[ -z "$LINK" ] && exit 0

CATEGORY=$(printf "youtube\ngit\narticle" | dmenu -i -l 10 -p "Save as:" \
	-nb "#1e1e2e" \
	-nf "#cdd6f4" \
	-sb "#89b4fa" \
	-sf "#1e1e2e")

[ -z "$CATEGORY" ] && exit 0

echo "$LINK" >>"$BASE/$CATEGORY.txt"

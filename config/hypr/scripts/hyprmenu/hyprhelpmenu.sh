#!/bin/env bash

FILE="$HOME/.config/hypr/helpmenu/hyprhelpmenu.txt"

cat "$FILE" | rofi -dmenu -i -markup-rows -p "Hypr Keybinds" \
    -theme-str '
window {
    width: 650px;
    padding: 18px;
    border-radius: 0px;
    border: 1px;
    border-color: #7aa2f7;
    background-color: rgba(26,27,38,0.95);
}

listview {
    lines: 20;
    fixed-height: true;
    scrollbar: false;
    spacing: 1px;
    background-color: rgba(26,27,38,0.95);
}

element {
    padding: 1px;
    border-radius: 0px;
    background-color: rgba(26,27,38,0.95);
    text-color: #cdd6f4;
}

element selected {
    background-color: rgba(122,162,247,0.25);
    text-color: #cdd6f4;
}

prompt {
    text-color: #7dcfff;
    font: "JetBrainsMono Bold 15";
}
'

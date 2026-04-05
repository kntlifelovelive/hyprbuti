# ~/.config/zsh/keybindings/wifi.zsh


# WiFi status (Alt+s)
wifi-status-widget() {
    wifi-status
    zle reset-prompt
}
zle -N wifi-status-widget
bindkey '^[s' wifi-status-widget

# WiFi info (Alt+i)
wifi-info-widget() {
    wifi-info
    zle reset-prompt
}
zle -N wifi-info-widget
bindkey '^[i' wifi-info-widget


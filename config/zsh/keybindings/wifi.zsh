# ~/.config/zsh/keybindings/wifi.zsh

# WiFi passwords (Alt+w)
wifi-passwords-widget() {
    wifi-passwords
    zle reset-prompt
}
zle -N wifi-passwords-widget
bindkey '^[w' wifi-passwords-widget

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

# Alternative: Alt+Shift+W (if needed)
wifi-passwords-alt-widget() {
    wifi-passwords
    zle reset-prompt
}
zle -N wifi-passwords-alt-widget
bindkey '^[W' wifi-passwords-alt-widget

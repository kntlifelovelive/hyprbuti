# ~/.config/zsh/functions/wifi.zsh

# Show all Wi-Fi passwords (based on working script)
wifi-passwords() {
    echo ""
    echo "󰤨 \e[1;36mWi-Fi Passwords\e[0m"
    echo "󰣇 \e[1;90m================================\e[0m"
    echo ""
    
    local found=0
    
    # Use the same method as your working script
    sudo grep -r psk= /etc/NetworkManager/system-connections 2>/dev/null | while IFS=: read -r filepath psk_value; do
        # Get SSID from filename
        local ssid=$(basename "$filepath" .nmconnection)
        # Get password (remove "psk=" prefix)
        local password="${psk_value#psk=}"
        found=1
        
        # Display with Nerd Font icons
        echo -e "󰤨 \e[1;33m$ssid\e[0m"
        echo -e "   󰌾 \e[1;32m$password\e[0m"
        echo -e "   󰣇 \e[1;90m---\e[0m"
        echo ""
    done
    
    if [[ $found -eq 0 ]]; then
        echo -e "󰅙 \e[1;31mNo saved Wi-Fi passwords found\e[0m"
    fi
    
    echo "󰣇 \e[1;90m================================\e[0m"
}

# WiFi status
wifi-status() {
    local interface=$(ip link show | grep -E "^[0-9]+: wl" | awk -F': ' '{print $2}' | head -1)
    
    if [[ -z "$interface" ]]; then
        echo -e "󰅙 \e[1;31mNo Wi-Fi interface found\e[0m"
        return
    fi
    
    local ssid=$(iwgetid -r 2>/dev/null)
    local signal=$(grep "$interface" /proc/net/wireless 2>/dev/null | awk '{print int($3)}')
    
    if [[ -n "$ssid" ]]; then
        local signal_icon=""
        if [[ -n "$signal" ]]; then
            if [[ $signal -ge 70 ]]; then
                signal_icon="󰤨"
            elif [[ $signal -ge 50 ]]; then
                signal_icon="󰤥"
            elif [[ $signal -ge 30 ]]; then
                signal_icon="󰤢"
            else
                signal_icon="󰤯"
            fi
            signal_display="${signal_icon} \e[1;36m${signal}%\e[0m"
        else
            signal_display="󰤨 \e[1;36mN/A\e[0m"
        fi
        
        echo -e "󰤨 \e[1;32mConnected:\e[0m \e[1;33m$ssid\e[0m"
        echo -e "   󰤨 Signal: $signal_display"
    else
        echo -e "󰤨 \e[1;31mNot connected to any Wi-Fi\e[0m"
    fi
}

# Combined info
wifi-info() {
    echo ""
    wifi-status
    echo ""
    wifi-passwords
}

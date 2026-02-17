#!/usr/bin/env bash

BT_SERVICE="bluetooth"
TIMEOUT=15
RETRY=2

# --- Zenity Notify Function ---
noti() {
	zenity --info --title="Bluetooth" --text="$1" --width=220 --height=65
}

start_bt() {
	# start service if stopped
	if ! systemctl is-active --quiet $BT_SERVICE; then
		systemctl start $BT_SERVICE
		sleep 1
	fi

	bluetoothctl power on >/dev/null 2>&1

	# start tray icon safely (only if tray exists)
	# if command -v blueman-applet >/dev/null; then
	# 	if ! pgrep -x blueman-applet >/dev/null; then
	# 		blueman-applet >/dev/null 2>&1 &
	# 		disown
	# 	fi
	# fi
}

stop_bt() {
	bluetoothctl power off >/dev/null 2>&1
	systemctl disable $BT_SERVICE >/dev/null 2>&1
	systemctl stop $BT_SERVICE >/dev/null 2>&1
	# pkill -x blueman-applet 2>/dev/null
	noti "Bluetooth stopped to save RAM"
	# show_notify "Bluetooth stopped to save RAM"
}

scan_devices() {
	bluetoothctl scan on >/dev/null 2>&1 &
	SCAN_PID=$!
	sleep 5
	bluetoothctl scan off >/dev/null 2>&1
	kill $SCAN_PID 2>/dev/null
}

choose_device() {
	DEVICES=$(bluetoothctl devices)

	if [ -z "$DEVICES" ]; then
		noti "No devices found"
		exit 1
	fi

	CHOICE=$(echo "$DEVICES" | rofi -dmenu -i -markup-rows -p "Bluetooth" \
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
    lines: 10;
    fixed-height: true;
    scrollbar: false;
    spacing: 2px;
}
element {
    padding: 6px;
    text-color: #cdd6f4;
}
element selected {
    background-color: rgba(122,162,247,0.25);
}
prompt {
    text-color: #7dcfff;
    font: "JetBrainsMono Bold 14";
}')

	[ -z "$CHOICE" ] && exit 0

	MAC=$(echo "$CHOICE" | awk '{print $2}')
	NAME=$(echo "$CHOICE" | cut -d' ' -f3-)
}

connect_device() {
	for ((i = 1; i <= RETRY; i++)); do

		bluetoothctl pair "$MAC" >/dev/null 2>&1
		bluetoothctl trust "$MAC" >/dev/null 2>&1

		if bluetoothctl connect "$MAC" >/dev/null 2>&1; then
			noti "Connected: $NAME"
			return
		fi

		sleep 2
	done

	noti "Connection failed"
	# show_notify "Connection failed"
	stop_bt
	exit 1
}

monitor_disconnect() {
	while bluetoothctl info "$MAC" | grep -q "Connected: yes"; do
		sleep 5
	done

	noti "Disconnected. Waiting $TIMEOUT seconds..."
	sleep $TIMEOUT

	if ! bluetoothctl info "$MAC" | grep -q "Connected: yes"; then
		stop_bt
	fi
}

# -------- MAIN --------

start_bt
scan_devices
choose_device
connect_device
monitor_disconnect

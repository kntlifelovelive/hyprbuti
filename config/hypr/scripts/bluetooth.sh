#!/usr/bin/env bash

BT_SERVICE="bluetooth"

# ---------- YAD Notify ----------

noti() {
	zenity --info --title="Bluetooth" --text="$1" --timeout=4 --width=220 --height=65
}

# ---------- Start Bluetooth ----------
start_bt() {
	systemctl enable $BT_SERVICE >/dev/null 2>&1
	systemctl start $BT_SERVICE >/dev/null 2>&1
	bluetoothctl power on >/dev/null 2>&1
}

# ---------- Scan Devices ----------
scan_devices() {
	OUTPUT=$(
		bluetoothctl <<EOF
power on
agent on
default-agent
scan on
sleep 6
scan off
devices
EOF
	)
	DEVICES=$(echo "$OUTPUT" | grep "^Device" | awk '{
        mac=$2
        name=""
        for(i=3;i<=NF;i++) name=name $i " "
        print mac "  |  " name
    }')

	if [ -z "$DEVICES" ]; then
		noti "No devices found"
		exit 1
	fi

	SELECTED=$(echo "$DEVICES" | rofi -dmenu -i -markup-rows -p "Bluetooth" \
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
    font: "sans-serif 14";
}')

	[ -z "$SELECTED" ] && exit 0

	MAC=$(echo "$SELECTED" | awk '{print $1}')
	NAME=$(echo "$SELECTED" | cut -d'|' -f2 | xargs)
}

# ---------- Connect Device (Fixed) ----------
connect_device() {

	bluetoothctl pair "$MAC" >/dev/null 2>&1
	bluetoothctl trust "$MAC" >/dev/null 2>&1

	# Retry connect 2
	for _ in 1 2; do
		if bluetoothctl connect "$MAC" >/dev/null 2>&1; then
			noti "Connected bluetooth devices: $NAME"
			return
		fi
		sleep 2
	done

	noti "Connection failed. Make sure device is on & in range."
	exit 1
}
# ---------- MAIN ----------
start_bt
scan_devices
connect_device

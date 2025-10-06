#!/bin/bash

# Define your Wi-Fi interface (use `iwctl device list` to check)
INTERFACE="wlan0"

# Get Wi-Fi list (ignores headers/lines)
wifi_list=$(iwctl station "$INTERFACE" get-networks | \
    awk 'NR>4 && NF>0 {print $1, $2, $3}' | sort -k3 -r)

# Format each line with signal icon
formatted=$(echo "$wifi_list" | awk '
function icon(signal) {
    bars = length(signal);
    if (bars >= 4) return "󰤨";
    else if (bars == 3) return "󰤥";
    else if (bars == 2) return "󰤢";
    else if (bars == 1) return "󰤟";
    else return "󰤠";
}
{
    ssid=$1;
    security=$2;
    signal=$3;
    print icon(signal) "  " ssid "  [" security "]";
}')

chosen=$(echo "$formatted" | rofi -dmenu -p "Wi-Fi" -i)
[[ -z "$chosen" ]] && exit 0

# Extract SSID and security
ssid=$(echo "$chosen" | sed 's/^[^ ]*  //' | awk '{print $1}')
security=$(echo "$chosen" | awk -F'[][]' '{print $2}')

# Get current connection
current=$(iwctl station "$INTERFACE" show | awk -F': ' '/Connected network/ {print $2}')

if [[ "$ssid" == "$current" ]]; then
    dunstify "Wi-Fi" "Already connected to $ssid"
    exit 0
fi

# Prompt for password if network is secured
if [[ "$security" != "open" ]]; then
    password=$(rofi -dmenu -password -p "Password for $ssid")
    [[ -z "$password" ]] && exit 1
    iwctl --passphrase "$password" station "$INTERFACE" connect "$ssid" \
        && dunstify "Wi-Fi" "Connected to $ssid" \
        || dunstify "Wi-Fi" "Connection failed"
else
    iwctl station "$INTERFACE" connect "$ssid" \
        && dunstify "Wi-Fi" "Connected to $ssid" \
        || dunstify "Wi-Fi" "Connection failed"
fi

# Rescan in background
iwctl station "$INTERFACE" scan >/dev/null 2>&1 &

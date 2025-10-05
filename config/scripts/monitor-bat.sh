#!/bin/bash
LOW=30
CRITICAL=10
TOP=95

ICON_PATH=$HOME/.icons
SOUND_PATH=$HOME/.sounds

STATE_FILE="/tmp/last_battery_state"
LEVEL_FILE="/tmp/last_battery_level"

get_battery_percentage() {
  upower -i "$(upower -e | grep 'BAT')" \
  | awk -F: '/percentage/ {
      gsub(/[%[:space:]]/, "", $2);
      print $2; exit
    }'
}

get_battery_state() {
  upower -i "$(upower -e | grep 'BAT')" \
  | awk -F: '/state/ {gsub(/^[ \t]+/, "", $2); print $2}'
}

send() {  
  local app=$1 icon=$2 title=$3 body=$4 sound=$5

  notify-send -a "${app}" \
              -i $ICON_PATH/"${icon}.svg" \
              "$title" "$body"
  paplay $SOUND_PATH/$sound
}

BATTERY_LEVEL=$(get_battery_percentage)
BATTERY_STATE=$(get_battery_state)

LAST_STATE="none"
[ -f "$STATE_FILE" ] && LAST_STATE=$(cat "$STATE_FILE")

LAST_LEVEL=100
[ -f "$LEVEL_FILE" ] && LAST_LEVEL=$(cat "$LEVEL_FILE")

# Save for next run
echo "$BATTERY_STATE" > "$STATE_FILE"
echo "$BATTERY_LEVEL" > "$LEVEL_FILE"

if [ $BATTERY_STATE == "discharging" ]; then
	if [ $LAST_STATE != "discharging" ]; then
	 	send gray unplug "Discharging" "Battery charger disconnected" unplug.mp3
	fi
    
	if [[ $BATTERY_LEVEL -le $CRITICAL && 
	    ( $LAST_LEVEL -gt $CRITICAL || $LAST_STATE != "discharging" ) ]]; then
		send red battery-warning "Battery Critical" "Please plug in your device" battery-critical.mp3
	fi

	if [[ $BATTERY_LEVEL -le $LOW && $BATTERY_LEVEL -gt $CRITICAL && 
	    ( $LAST_LEVEL -gt $LOW || $LAST_STATE != "discharging" ) ]]; then
	    send yellow battery-low "Battery Low" "Your battery is low" battery-low.mp3
	fi
fi

if [ $BATTERY_STATE == "charging" ]; then
	if [ $LAST_STATE != "charging" ]; then
	    send blue battery-charging "Charging" "Battery charger connected" plugin.mp3
	fi

	if [ $BATTERY_LEVEL -ge $TOP ] && [ $LAST_LEVEL -lt $TOP ]; then
	    send green battery-full "Battery Full" "You can unplug your device" battery-full.mp3
	fi
fi

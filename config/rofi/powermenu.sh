#!/usr/bin/env bash

# Options
shutdown=''
lock=''
reboot=''
sleep='󰒲'
logout='󰍃'

# Uptime
uptime="`uptime -p | sed -e 's/up //g'`"

# Rofi CMD
powermenu() {
echo -e "$lock\n$suspend\n$logout\n$reboot\n$shutdown" \
 | rofi -dmenu \
		-p "Uptime: $uptime" \
		-mesg "Uptime: $uptime" \
		-theme ./powermenu.rasi
}

chosen="$(powermenu)"
case "$chosen" in
    "$shutdown") systemctl poweroff ;;
    "$reboot") systemctl reboot ;;
    "$lock") hyprlock ;;
    "$sleep") systemctl sleep ;;
    "$logout") hyprctl dispatch exit ;; 
    *) exit 0 ;;
esac

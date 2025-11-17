#!/usr/bin/env bash

# Options
lock=''
sleep='󰒲'
logout='󰍃'
reboot=''
shutdown=''

# Uptime
uptime="`uptime -p | sed -e 's/up //g'`"

# Rofi CMD
powermenu() {
echo -e "$lock\n$sleep\n$logout\n$reboot\n$shutdown\n" \
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

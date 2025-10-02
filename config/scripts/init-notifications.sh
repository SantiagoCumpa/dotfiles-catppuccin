#!/bin/bash

# Kill instances
pkill -f "dbus-monitor.*org.freedesktop.UPower" 2>/dev/null  

MONITOR_CMD="dbus-monitor --system \"type='signal',sender='org.freedesktop.UPower',interface='org.freedesktop.DBus.Properties'\""

eval $MONITOR_CMD | while read -r line; do
    ~/.config/scripts/battery-monitor.sh
done

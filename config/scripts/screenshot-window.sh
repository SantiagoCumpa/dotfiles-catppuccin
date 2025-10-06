#!/bin/bash

# Create a temporary file for the screenshot
TMPFILE=$(mktemp /tmp/hyprshot-XXXXXX.png)

# Take a screenshot of the active window and save to the temp file
hyprshot -m window -o "$(dirname "$TMPFILE")" -f "$(basename "$TMPFILE")" -s

# If the screenshot failed (no file), exit
[[ ! -f "$TMPFILE" ]] && exit 1

# Open Satty to edit the image
satty -f "$TMPFILE" --early-exit
paplay $SOUND_PATH/screen-capture.ogg

# Optional: manually ensure clipboard update
if command -v wl-copy &>/dev/null; then
    wl-copy < "$TMPFILE"
fi

# Clean up temp file
rm -f "$TMPFILE"

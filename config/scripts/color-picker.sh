#!/bin/bash

# -------------------------------
# Rofi + Hyprpicker Color Selector
# -------------------------------

formats=(
    "  hex  [#rrggbb]"
    "  rgb  [rgb(r,g,b)]"
    "  hsl  [hsl(h,s,l)]"
    "  cmyk [cmyk(c,m,y,k)]"
    "  hsv  [hsv(h,s,v)]"
)

# Rofi launcher
launch_rofi() {
	rofi -dmenu \
		 -mesg "Select color format" \
		 -theme $ROFI_PATH/colorpicker.rasi
}

chosen=$(printf '%s\n' "${formats[@]}" | launch_rofi)

[[ -z "$chosen" ]] && exit 0

format=$(echo "$chosen" | awk '{print $2}')

sleep 0.2
color=$(hyprpicker --format "$format")

[[ -z "$color" ]] && exit 0

paplay $SOUND_PATH/pick.mp3 &
wl-copy "$color"
notify-send -i $ICON_PATH/pipette.svg -a gray "Color [$color]($format) on clipboard"

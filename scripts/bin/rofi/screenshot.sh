#!/usr/bin/env bash

otify_cmd="notify-send"

time=$(date +%Y-%m-%d-%H-%M-%S)
dir="$(xdg-user-dir PICTURES)/Screenshots"
file="Screenshot_${time}.png"

notify_view() {
    ${notify_cmd} "Copied to clipboard"
}

copy_shot() {
    # ${notify_cmd} "Copied to clipboard"
    tee "$file" | xclip -selection clipboard -t image/png
}

shot_now() {
    cd "${dir}" && sleep 0.5 && maim -u -f png | tee "$file" | copy_shot
}

shot_win() {
    cd "${dir}" && maim -u -f png -i "$(xdotool getactivewindow)" | tee "$file" | copy_shot
}

shot_area() {
    cd "${dir}" && maim -u -f png -s -b 2 -c 0.35,0.55,0.85,0.25 -l | tee "$file" | copy_shot
}

if [[ ! -d "dir" ]]; then
    mkdir -p "$dir"
fi

screen=" screen"
window=" window"
area=" area"

options="${screen}\n${window}\n${area}"
chosen="$(echo -e "$options" | rofi -dmenu -i -p 'Screenshot')"

case $chosen in
"$screen")
    shot_now
    ;;
"$window")
    shot_win
    ;;
"$area")
    shot_area
    ;;
esac

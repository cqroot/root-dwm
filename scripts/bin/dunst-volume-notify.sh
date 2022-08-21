#!/usr/bin/env bash

volume_value=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $(($SINK + 1)) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')

if [[ $volume_value -eq 0 ]]; then
    icon="/usr/share/icons/Papirus/24x24/panel/audio-volume-muted.svg"
elif [[ $volume_value -le 30 ]]; then
    icon="/usr/share/icons/Papirus/24x24/panel/audio-volume-low.svg"
elif [[ $volume_value -le 60 ]]; then
    icon="/usr/share/icons/Papirus/24x24/panel/audio-volume-medium.svg"
else
    icon="/usr/share/icons/Papirus/24x24/panel/audio-volume-high.svg"
fi

dunstify \
    -h "int:value:${volume_value}" \
    -h string:category:volume \
    -i ${icon} \
    "${volume_value}%"

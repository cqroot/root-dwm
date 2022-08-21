#!/usr/bin/env bash

BLACK='#21222c'
WHITE='#f8f8f2'
GREY='#44475a'
DARKBLUE='#bd93f9'
RED=#BF616A

print_update() {
    pacman_update_num=$(checkupdates | wc -l)
    yay_update_num=$(pacman -Qu | wc -l)

    echo -n $((pacman_update_num + yay_update_num))
}

print_mem() {
    echo -n "^c$WHITE^^b$BLACK^  "

    grep -E 'MemTotal|MemAvailable' /proc/meminfo | awk '{print $2}' | xargs | awk '{printf ("%d%%", 100-$2/$1*100)}'
}

print_cpu() {
    echo -n "^c$WHITE^^b$BLACK^  "
    grep 'cpu ' /proc/stat | awk '{printf ("%d%%", ($2+$4)/($2+$4+$5)*100)}'
}

print_volume() {
    volume_off_icon="婢"
    volume_low_icon="奄"
    volume_medium_icon="奔"
    volume_high_icon="墳"

    echo -n "^c$WHITE^^b$BLACK^ "

    SINK=$(pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1)
    VOLUME=$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $((SINK + 1)) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')

    if [ "$VOLUME" -eq 0 ]; then
        echo -n $volume_off_icon
    # elif [ "$VOLUME" -lt 33 ]; then
    #     echo -n $volume_low_icon
    # elif [ "$VOLUME" -lt 66 ]; then
    #     echo -n $volume_medium_icon
    else
        echo -n $volume_high_icon
    fi

    echo -n " ${VOLUME}%"
}

print_time() {
    echo -n "^c$BLACK^"
    echo -n "^b$DARKBLUE^"

    echo -n " $(date "+%a %b %d %H:%M")"
}

update_cnt=10000
update_num=0
update_prefix="^c$WHITE^"
while true; do
    if [ $update_cnt -gt 300 ]; then
        update_num=$(print_update)
        update_cnt=0

        if [ "${update_num}" -eq 0 ]; then
            update_prefix=" ^c$WHITE^"
        else
            update_prefix=" ^c$RED^"
        fi
    fi

    sep="^c$GREY^^b$BLACK^"
    xsetroot -name " ${update_prefix}${update_num} $(print_volume) ${sep}$(print_cpu) ${sep}$(print_mem) $(print_time) "
    sleep 1s

    update_cnt=$((update_cnt + 1))
done

#!/usr/bin/env bash

BLACK='#21222c'
WHITE='#f8f8f2'
GREY='#44475a'
DARKBLUE='#bd93f9'
RED=#BF616A

update_cnt=10000
update_num=0
print_update() {
    if [ $update_cnt -gt 300 ]; then
        pacman_update_num=$(checkupdates | wc -l)
        yay_update_num=$(pacman -Qu | wc -l)

        update_num=$((pacman_update_num + yay_update_num))

        update_cnt=0
    fi

    if [ $update_num -eq 0 ]; then
        echo -n "^c$WHITE^"
    else
        echo -n "^c$RED^"
    fi

    echo -n " ${update_num}"

    update_cnt=$((update_cnt + 1))
}

print_mem() {
    echo -n "^c$WHITE^^b$BLACK^ M "

    grep -E 'MemTotal|MemAvailable' /proc/meminfo | awk '{print $2}' | xargs | awk '{printf ("%d%%", 100-$2/$1*100)}'
}

print_cpu() {
    echo -n "^c$WHITE^^b$BLACK^ C "
    grep 'cpu ' /proc/stat | awk '{printf ("%d%%", ($2+$4)/($2+$4+$5)*100)}'
}

print_volume() {
    echo -n "^c$WHITE^^b$BLACK^ 墳 "

    SINK=$(pactl list short sinks | sed -e 's,^\([0-9][0-9]*\)[^0-9].*,\1,' | head -n 1)
    echo -n "$(pactl list sinks | grep '^[[:space:]]Volume:' | head -n $((SINK + 1)) | tail -n 1 | sed -e 's,.* \([0-9][0-9]*\)%.*,\1,')%"
}

print_time() {
    echo -n "^c$BLACK^"
    echo -n "^b$DARKBLUE^"

    echo -n " $(date "+%a %b %d %H:%M")"
}

while true; do
    sep="^c$GREY^^b$BLACK^"
    xsetroot -name " $(print_update) ${sep}$(print_volume) ${sep}$(print_cpu) ${sep}$(print_mem) $(print_time) "
    sleep 1s
done

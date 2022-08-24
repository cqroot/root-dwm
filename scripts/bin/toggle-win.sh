#!/usr/bin/env bash

toggle_win() {
    win_id=$1

    if [ -z "${win_id}" ]; then
        return
    fi

    status=$(xwininfo -id "${win_id}" | grep 'Map State' | awk '{print $3}')

    if [[ ${status} == "IsViewable" ]]; then
        xdotool windowunmap "${win_id}"
    else
        xdotool windowmap "${win_id}"
    fi
}

case $1 in
"Subl")
    win_id=$( (
        xdotool search --name "Sublime Text - Sublime Text"
        xdotool search --class "Subl"
    ) | sort | uniq -d)

    if [ -z "${win_id}" ]; then
        subl &
        win_id=$( (
            xdotool search --name "Sublime Text - Sublime Text"
            xdotool search --class "Subl"
        ) | sort | uniq -d)
    fi
    ;;

"Cherrytree")
    for id in $(xdotool search --class "Cherrytree"); do
        if [ "$(xwininfo -id "${id}" | grep "^xwininfo" | awk -F'"' '{print $(NF-1)}')" != "cherrytree" ]; then
            win_id=$id
        fi
    done
    ;;

esac

toggle_win "${win_id}"

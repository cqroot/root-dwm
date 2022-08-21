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
"subl")
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

esac

toggle_win "${win_id}"

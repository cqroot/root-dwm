#!/usr/bin/env bash

ROOTDWM_PATH=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
export ROOTDWM_PATH

sh "${ROOTDWM_PATH}/bin/dwm-bar.sh" &
pgrep -x sxhkd >/dev/null || sxhkd -c "${ROOTDWM_PATH}/conf/sxhkdrc" &
pgrep -x xautolock >/dev/null ||
    xautolock -time 30 -corners 00+- -cornerdelay 1 -locker "sh ${ROOTDWM_PATH}/bin/lock.sh" &

sh "$HOME/.bin/autostart.sh" &

while true; do
    dwm 2>~/.dwm.log
    # dwm >/dev/null 2>&1
done

# exec dwm

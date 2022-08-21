#!/usr/bin/env bash

lock=" Lock"
logout=" Logout"
poweroff=" Poweroff"
reboot=" Reboot"

options="${lock}\n${logout}\n${poweroff}\n${reboot}"
chosen=$(echo -e "${options}" | rofi -dmenu -i -p "⏻")

case ${chosen} in
"${lock}")
    sh "${ROOTDWM_PATH}/bin/lock.sh"
    ;;
"${logout}")
    loginctl terminate-user "$(whoami)"
    ;;
"${poweroff}")
    poweroff
    ;;
"${reboot}")
    reboot
    ;;
esac

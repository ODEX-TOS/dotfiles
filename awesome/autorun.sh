#!/usr/bin/env bash

function run() {
  if ! pgrep -f "$1"; then
    "$@" &
  fi
}

setxkbmap "$(cat /etc/vconsole.conf | cut -d= -f2 | cut -d- -f1)"

nohup tos t s "$(cat ~/.config/tos/theme | head -n3 | tail -n1)" &>/dev/null &
nohup tos theme daemon &>/dev/null &# launch a tos daemon
touchpad.sh &

run st

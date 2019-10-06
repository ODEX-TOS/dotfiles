#!/usr/bin/env bash

function run() {
  if ! pgrep -f "$1"; then
    "$@" &
  fi
}

setxkbmap "$(cut -d= -f2 /etc/vconsole.conf | cut -d- -f1)"

nohup tos t s "$(head -n3 ~/.config/tos/theme | tail -n1)" &>/dev/null &
nohup tos theme daemon &>/dev/null &# launch a tos daemon
touchpad.sh &

run st

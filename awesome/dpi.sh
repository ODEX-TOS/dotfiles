#!/bin/bash

val=$(printf "0.25\n0.5\n0.75\n1\n1.25\n1.5\n2\n" | rofi -dmenu -theme /etc/xdg/awesome/configuration/rofi/sidebar/rofi.rasi) # get the requested dpi

screens=$(xrandr | grep " connected" | cut -d " " -f1) # get all screens

for screen in $screens; do
    tos screen dpi "$screen" "$val"x"$val" # set dpi for every screen
done


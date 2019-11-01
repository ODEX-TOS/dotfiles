#!/bin/bash

# MIT License
# 
# Copyright (c) 2019 PapyElGringo
# Copyright (c) 2019 Tom Meyers
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

val=$(printf "0.25\n0.5\n0.75\n1\n1.25\n1.5\n2\n" | rofi -dmenu -theme /etc/xdg/awesome/configuration/rofi/sidebar/rofi.rasi) # get the requested dpi
original=$(grep "scale=" ~/.config/tos/theme | head -n1 | cut -d " " -f2)
screens=$(xrandr | grep " connected" | cut -d " " -f1) # get all screens

function set-screen {
    for screen in $screens; do
        tos screen dpi "$screen" "$1" # set dpi for every screen
    done
}

set-screen "$val"x"$val"
# TODO: a timer should run while waiting for the rofi output
# If the timer expires that we should reset the screen
val=$(printf "Is the scaling correct\nyes\nno\n" | rofi -dmenu -theme /etc/xdg/awesome/configuration/rofi/sidebar/rofi.rasi) # get the requested dpi
if [[ "$val" == "no" ]]; then
        set-screen "$original"
fi


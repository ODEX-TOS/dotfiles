#!/bin/bash

# get all screens
screens=$(xrandr | grep ' connected' | cut -f1 -d' ')

# get the smallest resolution
small=$(xrandr | grep " connected" | cut -f1,3 -d ' ' | cut -f1 -d '+' | awk 'BEGIN{small=999999999}{split($2,a,"x"); b=(a[1] * a[2]); if(b < small){small=b; print $1, $2}}' | sort | tail -n1)
res=$(echo "$small" | cut -f2 -d ' ')
name=$(echo "$small" | cut -f1 -d ' ')

old="$IFS"
IFS=$'\n'
xrandrCalc=""
for screen in $screens; do
	if [[ "$screen" != "$name" ]]; then
		xrandrCalc="$xrandrCalc--output $screen --mode $res --same-as $name"
	fi
done
IFS="$old"

xrandr --output $name --rate 60 --mode $res --fb $res --panning "$res*" $xrandrCalc

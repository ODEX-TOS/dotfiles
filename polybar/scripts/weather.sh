#!/bin/bash

cachedir=~/.cache/tos
cachefile=${0##*/}-$1


cacheage=$(($(date +%s) - $(stat -c '%Y' "$cachedir/$cachefile")))
temp=$(curl -s https://en.wttr.in\?0qnT | grep -E '(°C)|(°F)' | awk '{print $(NF-1),$NF}')

if [ ! -d $cachedir ]; then
    mkdir -p $cachedir
fi

if [ ! -f $cachedir/$cachefile ]; then
    touch $cachedir/$cachefile
    echo "$temp" > "$cachedir"/"$cachefile"
fi

if [[ "$temp" == *"°C"* ]] || [[ "$temp" == *"°F"* ]] && [[ "$cacheage" -gt 3600 ]]; then
    echo "$temp" > "$cachedir"/"$cachefile"
else
    temp=$(cat "$cachedir/$cachefile")
fi
echo $temp


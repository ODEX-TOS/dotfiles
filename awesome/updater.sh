#!/bin/bash

num=0
unique=$(yay -Sl | grep -E "\[installed: .*\]")
while read -r line ; do
        count=$(yay -Sl | grep " $(echo $line | cut -d ' ' -f2) " | wc -l)
        if [[ "$count" == *"1"* ]]; then
            num=$(($num+1))
        fi
done <<< "$unique"
echo "$num"


#!/bin/bash

# usage pass the colors to this file

for file in "$HOME"/.mozilla/firefox/*/chrome/userChrome.css; do
        # change all colors in /*START*/ colorcode /*END*/
        sed -i 's:START.*END:START*/ '"$1"' /*END:' "$file"
done

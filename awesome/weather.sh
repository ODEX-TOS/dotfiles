#!/bin/bash

weather=$(curl -sf https://en.wttr.in\?0qnT)

if [ ! -z "$weather" ]; then
    weather_temp=$(echo "$weather" | grep -E "(°C)|(°F)" | awk '{print $(NF-1),$NF}' | cut -d " " -f1  | cut -d "." -f1)
    # todo return icon
    weather_icon="test"
    weather_description=$(echo "$weather" | head -n1)

    echo "$weather_icon" "$weather_description"@@"$weather_temp"
else
    echo "..."
fi
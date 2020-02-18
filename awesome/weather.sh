#!/bin/bash

weather=$(curl -sf https://wttr.in/\?format="%l:%t:%C")
weather_icon="test"

# function used to extract the type of icon to display
# for more information about how and why this function behaves the way it does look at
# /etc/xdg/awesome/widgets/weather/icons and weather-update.lua
# see codes at https://github.com/chubin/wttr.in/blob/74d005c0ccb8235319343a8a5237f99f10287695/lib/constants.py for more information
function updateIcon {
    subtitle=$(echo "$weather" | cut -d: -f3)
    if [[ "$subtitle" == "Sunny" || "$subtitle" == "Clear" ]]; then
        weather_icon="110"
    elif [[ "$subtitle" == "" ]]; then
        weather_icon="220"
    elif [[ "$subtitle" == "Partly cloudy" ]]; then
        # cloud with sun
        weather_icon="330"
    elif [[ "$subtitle" == "" ]]; then
        # cloud during night
        weather_icon="440"
    elif [[ "$subtitle" == "Cloudy" || "$subtitle" == "Overcast" ]]; then
        weather_icon="550"
    elif [[ "$subtitle" == *"rain"* || "$subtitle" == *"drizzle" ]]; then
        weather_icon="660"
    elif [[ "$subtitle" == "Thundery outbreaks possible" ]]; then
        weather_icon="770"
    elif [[ "$subtitle" == "Patchy snow possible" || "$subtitle" == *"sleet"* || "$subtitle" == "Blowing snow" || "$subtitle" == "Blizzard" || "$subtitle" == *"Ice"* ]]; then
        weather_icon="880"
    elif [[ "$subtitle" == "Mist" || "$subtitle" == "Fog" || "$subtitle" == "Freezing fog" || "$subtitle" == *"snow"* ]]; then
        weather_icon="990"
    fi
}

if [ ! -z "$weather" ]; then
    weather_temp=$(echo "$weather" | cut -d: -f2 | sed 's/[+-]//g')
    # todo return icon
    updateIcon
    weather_description=$(echo "$weather" | cut -d: -f1)

    echo "$weather_icon" "$weather_description"@@"$weather_temp"
else
    echo "..."
fi
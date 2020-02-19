#!/bin/bash

weather=$(curl -sf https://wttr.in/\?format="%l:%t:%C")
weather_icon="test"

# Magic numbers used to denote the weather
SUNNY="110"
NIGHT_CLEAR="220"
CLOUDY_DAY="330"
CLOUDY_NIGHT="440"
CLOUDY="550"
RAIN="660"
STORM="770"
SNOW="880"
MIST="990"

START_NIGHT="21:00"
START_DAY="08:00"

# function used to extract the type of icon to display
# for more information about how and why this function behaves the way it does look at
# /etc/xdg/awesome/widgets/weather/icons and weather-update.lua
# see codes at https://github.com/chubin/wttr.in/blob/74d005c0ccb8235319343a8a5237f99f10287695/lib/constants.py for more information
function updateIcon {
    subtitle=$(echo "$weather" | cut -d: -f3)
    currentTime=$(date +%H:%M)
    if [[ "$subtitle" == "Sunny" || "$subtitle" == "Clear" ]]; then
        if [[ "$currentTime" > "$START_NIGHT" || "$currentTime" < "$START_DAY" ]]; then
            # moon
            weather_icon="$NIGHT_CLEAR"
        else
            # sun
            weather_icon="$SUNNY"
        fi
    elif [[ "$subtitle" == "Partly cloudy" ]]; then
        if [[ "$currentTime" > "$START_NIGHT" || "$currentTime" < "$START_DAY" ]]; then
            # cloudy during night
            weather_icon="$CLOUDY_NIGHT"
        else
            # cloudy during the day
            weather_icon="$CLOUDY_DAY"
        fi
    elif [[ "$subtitle" == "Cloudy" || "$subtitle" == "Overcast" ]]; then
        weather_icon="$CLOUDY"
    elif [[ "$subtitle" == *"rain"* || "$subtitle" == *"drizzle" ]]; then
        weather_icon="$RAIN"
    elif [[ "$subtitle" == "Thundery outbreaks possible" ]]; then
        weather_icon="$STORM"
    elif [[ "$subtitle" == "Patchy snow possible" || "$subtitle" == *"sleet"* || "$subtitle" == "Blowing snow" || "$subtitle" == "Blizzard" || "$subtitle" == *"Ice"* ]]; then
        weather_icon="$SNOW"
    elif [[ "$subtitle" == "Mist" || "$subtitle" == "Fog" || "$subtitle" == "Freezing fog" || "$subtitle" == *"snow"* ]]; then
        weather_icon="$MIST"
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
-- Provides:
-- evil::weather
--      temperature (integer)
--      description (string)
--      icon_code (string)

local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi

local clickable_container = require('widget.material.clickable-container')

local PATH_TO_ICONS = '/etc/xdg/awesome/widget/weather/icons/'

-- Configuration
local key       = ""    -- openweathermap_api_key
local city_id   = ""    -- openweathermap_city_id
local units     = "metric"    -- weather_units  metric(°C)/imperial(°F)

-- Don't update too often, because your requests might get blocked for 24 hours
local update_interval = 1200

-- Check units
if units == "metric" then
    weather_temperature_symbol = "°C"
elseif units == "imperial" then
    weather_temperature_symbol = "°F"
end


--  Weather script using your API KEY
local weather_details_script = "/bin/bash /etc/xdg/awesome/weather.sh"

  -- Sometimes it's too slow for internet to connect so the weather widget
  -- will not update until the next 20mins so this is helpful to update it
  -- 20seconds after logging in.
  gears.timer {
    timeout = 20,
    autostart = true,
    single_shot = true,
    callback  = function()
        awful.spawn.easy_async_with_shell(weather_details_script, function(stdout)
            print("STDOUT" .. stdout)
            local icon_code = string.sub(stdout, 1, 3) or "..."
            local weather_details = string.sub(stdout, 5)
            weather_details = string.gsub(weather_details, '^%s*(.-)%s*$', '%1')
            -- Replace "-0" with "0" degrees
            weather_details = string.gsub(weather_details, '%-0', '0')
            -- Capitalize first letter of the description
            weather_details = weather_details:sub(1,1):upper()..weather_details:sub(2)
            local description = weather_details:match('(.*)@@')
            local temperature = weather_details:match('@@(.*)')
            print(icon_code .. description .. temperature)
            if icon_code == "..." then
                awesome.emit_signal("widget::weather", "Maybe it's 10000", "No internet connection...", "")
            else
                awesome.emit_signal("widget::weather", tonumber(temperature), description, icon_code)
            end
        end)
    end
}

  -- Update widget every 1200 seconds/20mins
  awful.widget.watch(weather_details_script, update_interval, function(widget, stdout)
    local icon_code = string.sub(stdout, 1, 3)
    local weather_details = string.sub(stdout, 5)
    weather_details = string.gsub(weather_details, '^%s*(.-)%s*$', '%1')
    -- Replace "-0" with "0" degrees
    weather_details = string.gsub(weather_details, '%-0', '0')
    -- Capitalize first letter of the description
    weather_details = weather_details:sub(1,1):upper()..weather_details:sub(2)
    local description = weather_details:match('(.*)@@')
    local temperature = weather_details:match('@@(.*)')
    if icon_code == "..." then
        awesome.emit_signal("widget::weather", "Maybe it's 10000", "No internet connection...", "")
    else
        awesome.emit_signal("widget::weather", tonumber(temperature), description, icon_code)
    end
    collectgarbage('collect')
end)



awesome.connect_signal("widget::weather", function(temperature, description, icon_code)
    local icon
    local color
    local widgetIconName
    -- Set icon and color depending on icon_code
    if string.find(icon_code, "01d") then
        -- icon = sun_icon
        -- color = beautiful.xcolor3
        widgetIconName = 'sun_icon'
    elseif string.find(icon_code, "01n") then
        -- icon = moon_icon
        -- color = beautiful.xcolor4
        widgetIconName = 'moon_icon'
    elseif string.find(icon_code, "02d") then
        -- icon = dcloud_icon
        -- color = beautiful.xcolor3
        widgetIconName = 'dcloud_icon'
    elseif string.find(icon_code, "02n") then
        -- icon = ncloud_icon
        -- color = beautiful.xcolor6
        widgetIconName = 'ncloud_icon'
    elseif string.find(icon_code, "03") or string.find(icon_code, "04") then
        -- icon = cloud_icon
        -- color = beautiful.xcolor1
        widgetIconName = 'cloud_icon'
    elseif string.find(icon_code, "09") or string.find(icon_code, "10") then
        -- icon = rain_icon
        -- color = beautiful.xcolor4
        widgetIconName = 'rain_icon'
    elseif string.find(icon_code, "11") then
        -- icon = storm_icon
        -- color = beautiful.xcolor1
        widgetIconName = 'storm_icon'
    elseif string.find(icon_code, "13") then
        -- icon = snow_icon
        -- color = beautiful.xcolor6
        widgetIconName = 'snow_icon'
    elseif string.find(icon_code, "50") or string.find(icon_code, "40") then
        -- icon = mist_icon
        -- color = beautiful.xcolor5
        widgetIconName = 'mist_icon'
    else
        -- icon = whatever_icon
        -- color = beautiful.xcolor2
        widgetIconName = 'whatever_icon'
    end

    -- Update data. Global variables stored in widget.weather.init
    _G.weather_icon_widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
    _G.weather_description.text = description
    _G.weather_temperature.text = temperature .. weather_temperature_symbol
end)
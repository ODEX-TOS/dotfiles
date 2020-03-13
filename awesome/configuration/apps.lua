--[[
--MIT License
--
--Copyright (c) 2019 manilarome
--Copyright (c) 2020 Tom Meyers
--
--Permission is hereby granted, free of charge, to any person obtaining a copy
--of this software and associated documentation files (the "Software"), to deal
--in the Software without restriction, including without limitation the rights
--to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--copies of the Software, and to permit persons to whom the Software is
--furnished to do so, subject to the following conditions:
--
--The above copyright notice and this permission notice shall be included in all
--copies or substantial portions of the Software.
--
--THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--SOFTWARE.
]]

local filesystem = require('gears.filesystem')
local HOME = os.getenv('HOME')
local config = require('config')


function addHash(input)
    if input == nil then return nil end
    return "#" .. input
end

-- helper to retrieve current theme
local themefile = require('theme.config')
local mat_colors = require('theme.mat-colors')
--local color = mat_colors[themefile["primary"]].hue_500 or mat_colors.purple.hue_500
local color = mat_colors.purple.hue_500
local color = addHash(themefile["primary_hue_500"]) or color
print("theme color " ..color .. " primary:" .. themefile["primary"])

return {
  -- List of apps to start by default on some actions
  default = {
    terminal = os.getenv("TERMINAL") or 'st',
    editor = 'code-insiders',
    rofi = 'rofi -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi/sidebar/rofi.rasi',
    web = 'rofi -show Search -modi Search:' .. filesystem.get_configuration_dir() .. '/configuration/rofi/search.py' .. ' -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi/sidebar/rofi.rasi',
    rofiappmenu = 'rofi -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi/appmenu/drun.rasi',
    rofidpimenu = [[bash /etc/xdg/awesome/dpi.sh]],
    rofiwifimenu = [[bash /etc/xdg/awesome/wifi.sh]],
    lock = 'mantablockscreen -sc',
    quake = (os.getenv("TERMINAL") or 'st') .. ' -T QuakeTerminal'
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
    'compton --dbus --config ' .. config.getComptonFile(),
    'blueman-applet', -- Bluetooth tray icon
    'xfce4-power-manager', -- Power manager
    'xfsettingsd', -- Settings
    'xrdb $HOME/.Xresources',
    'nm-applet',
    'sh -c "/etc/xdg/awesome/firefox-color.sh \'' .. color .. '\'"',
  },
  bins = {
    coverUpdate = require('helper.extractcover').extractalbum
  }
}

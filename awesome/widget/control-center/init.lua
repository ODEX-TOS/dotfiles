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

local awful = require('awful')
local wibox = require('wibox')
local gears = require('gears')
local beautiful = require('beautiful')
local icons = require('theme.icons')
local mat_icon = require('widget.material.icon')


local apps = require('configuration.apps')
local dpi = require('beautiful').xresources.apply_dpi
local clickable_container = require('widget.material.clickable-container')

-- Load panel rules, it will create panel for each screen
require('widget.control-center.panel-rules')

local menu_icon = wibox.widget {
  icon = icons.logo,
  size = dpi(40),
  widget = mat_icon
}

local home_button = wibox.widget {
  wibox.widget {
    menu_icon,
    widget = clickable_container
  },
  bg = beautiful.background.hue_800 .. '99', -- beautiful.primary.hue_500,
  widget = wibox.container.background
}

home_button:buttons(
gears.table.join(
  awful.button(
    {},
    1,
    nil,
    function()
      _G.screen.primary.left_panel:toggle()
    end
  )
)
)

_G.screen.primary.left_panel:connect_signal(
  'opened',
  function()
    menu_icon.icon = icons.close
    _G.menuopened = true
  end
)

_G.screen.primary.left_panel:connect_signal(
  'closed',
  function()
    menu_icon.icon = icons.logo
    _G.menuopened = false
  end
)

return home_button

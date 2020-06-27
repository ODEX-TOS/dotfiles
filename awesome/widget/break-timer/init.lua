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

local wibox = require('wibox')
local awful = require('awful')
local mat_list_item = require('widget.material.list-item')
local mat_slider = require('widget.material.slider')
local clickable_container = require('widget.material.clickable-container')
local mat_icon = require('widget.material.icon')
local icons = require('theme.icons')
local dpi = require('beautiful').xresources.apply_dpi
local config = require('config')
local gears = require('gears')
local beautiful = require('beautiful')
local file = require('helper.file')

local width = dpi(200)
local height = width
local totalTime = 5
local currentTime = 0

local function leadingZero(number)
  if number < 10 then
    return "0" .. number
  end
  return number
end

local function numberInSecToMS(number)
  local minutes = math.floor(number / 60)
  local seconds = math.floor(number % 60)
  return leadingZero(minutes) .. ":" .. leadingZero(seconds)
end

local slider =
  wibox.widget {
  read_only = true,
  widget = mat_slider
}

local timerText = wibox.widget{
    markup = 'Break left: <b>00:00</b>',
    align  = 'center',
    valign = 'center',
    read_only = true,
    widget = wibox.widget.textbox
}


local FiveMinTimeOut = gears.timer {
  timeout   = 5 * 60,
  single_shot = true,
  callback  = function()
    _G.pause.show(totalTime)
  end
}

local countdownSlider = gears.timer {
  timeout   = 1,
  callback  = function()
    currentTime = currentTime + 1
    slider:set_value((currentTime / totalTime) * 100)
    timerText:set_markup_silently("Break Left: <b>" .. numberInSecToMS(totalTime - currentTime) .. "</b>")
    if currentTime >= totalTime then
      currentTime = 0
    end
    collectgarbage('collect')
  end
}

local delay = clickable_container(
  wibox.container.margin(
    wibox.widget{
      markup = 'Delay by 5 minutes',
      align  = 'center',
      valign = 'center',
      read_only = true,
      widget = wibox.widget.textbox
    },
  dpi(14),dpi(14),dpi(14),dpi(14))
)

delay:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        _G.pause.stop()
        FiveMinTimeOut:start()
        print("Break delayed by 5 minutes")
      end
    )
  )
)

local skip = clickable_container(
  wibox.container.margin(
    wibox.widget{
      markup = 'Skip pause',
      align  = 'center',
      valign = 'center',
      read_only = true,
      widget = wibox.widget.textbox
    },
  dpi(14),dpi(14),dpi(14),dpi(14))
)

skip:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        _G.pause.stop()
      end
    )
  )
)

local buttons = wibox.widget{
  {
    delay,
    skip,
    layout = wibox.layout.fixed.horizontal
  },
  halign = "center",
  bg = beautiful.bg_modal,
  widget = wibox.container.place()
}


local breakMeter =
  wibox.widget {
    wibox.widget {
      wibox.widget {
        icon = icons.sleep,
        size = dpi(24),
        widget = mat_icon
      },
      slider,
      widget = mat_list_item
    },
    timerText,
    buttons,
    spacing = dpi(20),
    layout  = wibox.layout.fixed.vertical
  }

_G.pause.start = function (time)
  print("Break time triggered started")
  currentTime = 0
  totalTime = time
  slider:set_value(currentTime)
  countdownSlider:start()
end

_G.pause.stopSlider = function ()
  countdownSlider:stop()
  print("Break stopped")
end

return breakMeter
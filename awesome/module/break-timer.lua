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
-- Load these libraries (if you haven't already)
local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = require("beautiful").xresources.apply_dpi

_G.pause = {}
local breakTimer = require("widget.break-timer")

awful.screen.connect_for_each_screen(
  function(s)
    breakOverlay =
      wibox(
      {
        visible = false,
        ontop = true,
        type = "normal",
        height = s.geometry.height,
        width = s.geometry.width,
        bg = beautiful.bg_modal,
        x = s.geometry.x,
        y = s.geometry.x
      }
    )
    -- Put its items in a shaped container
    breakOverlay:setup {
      -- Container
      {
        breakTimer,
        layout = wibox.layout.fixed.vertical
      },
      -- The real background color
      bg = beautiful.background.hue_800,
      valign = "center",
      halign = "center",
      widget = wibox.container.place()
    }

    breakbackdrop =
      wibox {
      ontop = true,
      visible = false,
      screen = s,
      bg = "#000000aa",
      type = "dock",
      x = s.geometry.x,
      y = s.geometry.y,
      width = s.geometry.width,
      height = s.geometry.height - dpi(40)
    }
  end
)

_G.pause.stop = function()
  breakbackdrop.visible = false
  breakOverlay.visible = false
  _G.pause.stopSlider()
  print("Stopping break timer")
end

_G.pause.show = function(time)
  breakbackdrop.visible = true
  breakOverlay.visible = true
  _G.pause.start(time)
  gears.timer {
    timeout = time,
    single_shot = true,
    autostart = true,
    callback = function()
      -- stop the break after x seconds
      _G.pause.stop()
    end
  }
  print("Showing break timer")
end

local split = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  if inputstr == nil then
    return t
  end
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

local current_time_inbetween = function(time_start, time_end)
  local time = os.date("*t")
  local time_start_split = split(time_start, ":")
  local time_end_split = split(time_end, ":")
  local time_start_hour = tonumber(time_start_split[1])
  local time_start_min = tonumber(time_start_split[2])
  local time_end_hour = tonumber(time_end_split[1])
  local time_end_min = tonumber(time_end_split[2])

  local currentTimeInMin = (time.hour * 60) + time.min

  return currentTimeInMin >= ((time_start_hour * 60) + time_start_min) and
    currentTimeInMin <= ((time_end_hour * 60) + time_end_min)
end

local breakTriggerTimer =
  gears.timer {
  timeout = tonumber(general["break_timeout"]) or (60 * 60 * 1),
  autostart = true,
  callback = function()
    time_start = general["break_time_start"] or "00:00"
    time_end = general["break_time_end"] or "23:59"
    if current_time_inbetween(time_start, time_end) then
      _G.pause.show(tonumber(general["break_time"]) or (60 * 5))
    else
      print("Break triggered but outside of time contraints")
    end
  end
}

-- Disable the global timer
-- Thus no more breaks will be triggered
_G.pause.disable = function()
  print("Disabeling break timer")
  breakTriggerTimer:stop()
end

return breakOverlay

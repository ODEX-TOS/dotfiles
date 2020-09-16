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

require("helper.luapath")
require('helper.logger')

print("Booting up...")

-- general conf is used by sentry (to opt out of it)
general = require('parser')(os.getenv('HOME') .. "/.config/tos/general.conf")

-- Setup Sentry error logging --
if not (general["tde_opt_out"] == "0") then
  _G.sentry = require('helper.errors')
else
  print("User opted out of stacktrace analysis")
  print("No information will be send to the tos developers")
end

local gears = require('gears')
local awful = require('awful')

plugins = require('parser')(os.getenv('HOME') .. "/.config/tos/plugins.conf")
tags = require('parser')(os.getenv('HOME') .. "/.config/tos/tags.conf")
keys = require('parser')(os.getenv('HOME') .. "/.config/tos/keys.conf")
floating = require('parser')(os.getenv('HOME') .. "/.config/tos/floating.conf")


require('awful.autofocus')
local beautiful = require('beautiful')

-- Theme
beautiful.init(require('theme'))
require('module.titlebar')()

-- Layout
require('layout')
awful.spawn.with_shell("/etc/xdg/awesome/autorun.sh &>/dev/null")
-- Init all modules
require('module.notifications')
require('module.auto-start')
require('module.decorate-client')
require('module.backdrop')
require('module.exit-screen')
require('module.quake-terminal')
require('module.brightness-slider-osd')
require('module.volume-slider-osd')
require('module.plugin-module')

-- Only activate the break timer if users what it
-- The default implementation of TOS doesn't use it
if general["break"] == "1" then
  require('module.break-timer')
end

require('module.battery-notifier')
require('collision')()
local wibox = require("wibox")

-- Setup all configurations
require('configuration.client')
require('configuration.tags')
_G.root.keys(require('configuration.keys.global'))
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(
  function(s)
    -- If wallpaper is a function, call it with the screen
    if beautiful.wallpaper then
        if type(beautiful.wallpaper) == "string" then
            if beautiful.wallpaper:sub(1, #"#") == "#" then
                gears.wallpaper.set(beautiful.wallpaper)
            elseif beautiful.wallpaper:sub(1, #"/") == "/" then
                gears.wallpaper.maximized(beautiful.wallpaper, s)
            end
        else
            beautiful.wallpaper(s)
        end
    end
  end
)

-- Signal function to execute when a new client appears.
_G.client.connect_signal(
  'manage',
  function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not _G.awesome.startup then
      awful.client.setslave(c)
    end

    if _G.awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
      awful.placement.under_mouse(c) -- This line added
      -- Prevent clients from being unreachable after screen count changes.
      awful.placement.no_offscreen(c)
    end
  end
)

-- Enable sloppy focus, so that focus follows mouse.

_G.client.connect_signal(
  'mouse::enter',
  function(c)
    c:emit_signal('request::activate', 'mouse_enter', {raise = true})
  end
)

_G.client.connect_signal(
  'focus',
  function(c)
    c.border_color = beautiful.border_focus
  end
)
_G.client.connect_signal(
  'unfocus',
  function(c)
    c.border_color = beautiful.border_normal
  end
)

-- menu takes a bit of time to load in.
-- because of this we put it in the back so the rest of the system can already behave
-- Look into awesome-freedesktop for more information
require('module.menu')

require("tutorial")

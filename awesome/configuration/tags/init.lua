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
local gears = require('gears')
local icons = require('theme.icons')
local config = require('parser')(os.getenv('HOME') .. "/.config/tos/tags.conf")

function getItem(item)
  return config[item] or nil
end

function getLayoutPerTag(number)
  local screen = "tag_" .. number
  print(screen)
  item = getItem(screen)
  print(item)
  if item ~= nil then
    if item == "0" or item == "dwindle" then
      return awful.layout.suit.spiral.dwindle
    end
    if item == "1" or item == "floating" then
      return awful.layout.suit.floating
    end
    if item == "2" or item == "tile" then
      return awful.layout.suit.tile
    end
    if item == "3" or item == "max" then
      return awful.layout.suit.max
    end
  else
    return awful.layout.suit.spiral.dwindle
  end
end

local tags = {
  {
    icon = icons.chrome,
    type = 'chrome',
    defaultApp = 'chrome',
    screen = 1,
    layout = awful.layout.suit.spiral.dwindle
  },
  {
    icon = icons.terminal,
    type = 'terminal',
    defaultApp = 'st',
    screen = 1,
    layout = awful.layout.suit.spiral.dwindle
  },
  {
    icon = icons.code,
    type = 'code',
    defaultApp = 'code-insiders',
    screen = 1,
    layout = awful.layout.suit.spiral.dwindle
  },
 --[[ {
    icon = icons.social,
    type = 'social',
    defaultApp = 'station',
    screen = 1
  },]]--
  {
    icon = icons.folder,
    type = 'files',
    defaultApp = 'nemo',
    screen = 1,
    layout = awful.layout.suit.spiral.dwindle
  },
  {
    icon = icons.music,
    type = 'music',
    defaultApp = 'spotify',
    screen = 1,
    layout = awful.layout.suit.spiral.dwindle
  },
  {
    icon = icons.game,
    type = 'game',
    defaultApp = '',
    screen = 1,
    layout = awful.layout.suit.spiral.dwindle
  },
  {
    icon = icons.art,
    type = 'art',
    defaultApp = 'gimp',
    screen = 1,
    layout = awful.layout.suit.spiral.dwindle
  },
  {
    icon = icons.lab,
    type = 'any',
    defaultApp = '',
    screen = 1,
    layout = awful.layout.suit.spiral.dwindle
  }
}

awful.layout.layouts = {
  awful.layout.suit.spiral.dwindle,
  awful.layout.suit.floating,
  awful.layout.suit.tile,
  awful.layout.suit.max
}

awful.screen.connect_for_each_screen(
  function(s)
    for i, tag in pairs(tags) do
      tag.layout = getLayoutPerTag(i)
      awful.tag.add(
        i,
        {
          icon = tag.icon,
          icon_only = true,
          layout = tag.layout,
          gap_single_client = false,
          gap = 4,
          screen = s,
          defaultApp = tag.defaultApp,
          selected = i == 1
        }
      )
    end
  end
)

_G.tag.connect_signal(
  'property::layout',
  function(t)
    local currentLayout = awful.tag.getproperty(t, 'layout')
    if (currentLayout == awful.layout.suit.max) then
      t.gap = 0
    else
      t.gap = 4
    end
  end
)

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

local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')

local naughty = require('naughty')
local dpi = require('beautiful').xresources.apply_dpi

local clickable_container = require('widget.material.clickable-container')

local PATH_TO_ICONS = '/etc/xdg/awesome/widget/music/icons/'

local mat_list_item = require('widget.material.list-item')

local apps = require('configuration.apps')
local config = require('config')

screen.connect_signal("request::desktop_decoration", function(s)
    -- Create the box
    local offsetx = dpi(500)
    local padding = dpi(10)
    musicPlayer = wibox
    {
      bg = '#00000000',
      visible = false,
      ontop = true,
      type = "normal",
      height = dpi(380),
      width = dpi(260),
      x = s.geometry.width - dpi(260) - dpi(10),
      y = padding/2,
    }

  musicbackdrop = wibox {
    ontop = true,
    visible = false,
    screen = s,
    bg = '#00000000',
    type = 'dock',
    x = s.geometry.x,
    y = s.geometry.y,
    width = s.geometry.width,
    height = s.geometry.height - dpi(40)
  }
end)

local grabber = awful.keygrabber {
  keybindings = {
      awful.key {
          modifiers = {},
          key       = 'Escape',
          on_press  = function()
            musicbackdrop.visible = false
            musicPlayer.visible = false
            print("Music Closing")
          end
      },
  },
  -- Note that it is using the key name and not the modifier name.
  stop_key           = 'Escape',
  stop_event         = 'release',
}

function togglePlayer()
  musicbackdrop.visible = not musicbackdrop.visible
  musicPlayer.visible = not musicPlayer.visible
  if musicPlayer.visible then
    grabber:start()
  else
    grabber:stop()
  end
end

musicbackdrop:buttons(
  awful.util.table.join(
    awful.button(
      {},
      1,
      function()
        togglePlayer()
      end
    )
  )
)

local widget =
  wibox.widget {
  {
    id = 'icon',
    image = PATH_TO_ICONS .. 'music' .. '.svg',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(14), dpi(14), dpi(8), dpi(8)))
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        togglePlayer()
      end
    )
  )
)

-- Album Cover
local cover =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    resize = true,
    clip_shape = gears.shape.rounded_rect,
  },
  layout = wibox.layout.fixed.vertical
}


function checkCover()
  local cmd = "if [[ -f /tmp/cover.jpg ]]; then print exists; fi"
  awful.spawn.easy_async_with_shell(cmd, function(stdout)
    if (stdout:match("%W")) then
      cover.icon:set_image(gears.surface.load_uncached('/tmp/cover.jpg'))
    else
      cover.icon:set_image(gears.surface.load_uncached(PATH_TO_ICONS .. 'vinyl' .. '.svg'))
    end
  end)
end

-- Update info
function updateInfo()
  _G.getTitle()
  _G.getArtist()
  apps.bins.coverUpdate()
  awesome.emit_signal("song_changed")
end


musicPlayer:setup {
  expand = "none",
    {
      {
        wibox.container.margin(cover, dpi(15), dpi(15), dpi(15), dpi(5)),
        layout = wibox.layout.fixed.vertical,
      },
      nil,
      {
        spacing = dpi(4),
        require('widget.music.progressbar'),
        require('widget.music.music-info'),
        require('widget.music.media-buttons'),
        layout = wibox.layout.flex.vertical,
      },
      layout = wibox.layout.fixed.vertical,
    },
    -- The real background color
    bg = beautiful.background.hue_800,
    -- The real, anti-aliased shape
    shape = function(cr, width, height)
              gears.shape.rounded_rect(
                cr,
                width,
                height,
                12)
            end,
    widget = wibox.container.background()
}


-- Check every X seconds if song status is
-- Changed outside this widget
local updateWidget = gears.timer {
    timeout = config.player_update,
    autostart = true,
    callback  = function()
      _G.checkIfPlaying()
      updateInfo()
    end
}

-- Execute if button is next/play/prev button is pressed
awesome.connect_signal("song_changed", function()
  gears.timer {
      timeout = config.player_reaction_time,
      autostart = true,
      single_shot = true,
      callback  = function()
        checkCover()
        awful.spawn('if [ -f /tmp/cover.jpg ]; then rm /tmp/cover.jpg; fi', false)
      end
    }
end)

widget.icon:set_image(PATH_TO_ICONS .. 'music' .. '.svg')

-- Update music info on Initialization
local function initMusicInfo()
  -- set the cover to vinyl until the right image is loaded
  cover.icon:set_image(gears.surface.load_uncached(PATH_TO_ICONS .. 'vinyl' .. '.svg'))
  apps.bins.coverUpdate()
  checkCover()
  _G.getTitle()
  _G.getArtist()
end
initMusicInfo()


return widget_button

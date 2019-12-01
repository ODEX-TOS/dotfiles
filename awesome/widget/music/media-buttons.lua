local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')

local naughty = require('naughty')
local dpi = require('beautiful').xresources.apply_dpi

local clickable_container = require('widget.material.clickable-container')

-- TODO: move the path to the icons to the correct location
local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/music/icons/'

local mat_list_item = require('widget.material.list-item')

local apps = require('configuration.apps')

local config = require("config")


local playButton =
  wibox.widget {
  {
    id = 'play',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

-- 'Public Function' , call it using '_G.checkIfPlaying()'
function checkIfPlaying()
  awful.spawn.easy_async_with_shell("playerctl status", function( stdout )
    if (stdout:match(".*Paused.*")) then
      playButton.play:set_image(gears.surface(PATH_TO_ICONS .. 'play.svg'))
    else
      playButton.play:set_image(gears.surface(PATH_TO_ICONS .. 'pause.svg'))
    end
  end)
end

local play_button = clickable_container(wibox.container.margin(playButton, dpi(14), dpi(14), dpi(7), dpi(7))) -- 4 is top and bottom margin
play_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        -- give spotify time to react
        awful.spawn('playerctl play-pause')
        -- give the music player time to react
        os.execute("sleep " .. config.player_reaction_time)
        checkIfPlaying()
        _G.updateInfo()
      end
    )
  )
)

-- Check if song is playing then change button image
checkIfPlaying()

local nextButton =
  wibox.widget {
  {
    id = 'next',
    image = PATH_TO_ICONS .. 'next.svg',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local next_button = clickable_container(wibox.container.margin(nextButton, dpi(14), dpi(14), dpi(7), dpi(7))) -- 4 is top and bottom margin
next_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn('playerctl next', false)
        _G.updateInfo()
        _G.checkCover()
      end
    )
  )
)

local prevButton =
  wibox.widget {
  {
    id = 'prev',
    image = PATH_TO_ICONS .. 'prev.svg',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local prev_button = clickable_container(wibox.container.margin(prevButton, dpi(14), dpi(14), dpi(7), dpi(7))) -- 4 is top and bottom margin
prev_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn('playerctl previous', false)
        _G.updateInfo()
        _G.checkCover()
      end
    )
  )
)

local mediabutton =
  wibox.widget {
    wibox.container.margin(prev_button, dpi(25), dpi(15)),
    wibox.container.margin(play_button, dpi(20), dpi(20)),
    wibox.container.margin(next_button, dpi(15), dpi(25)),
    layout = wibox.layout.flex.horizontal,
}

return mediabutton

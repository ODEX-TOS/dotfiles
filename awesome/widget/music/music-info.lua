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


-- Music Title
local musicTitle =
  wibox.widget {
  {
    id = 'title',
    font = 'SFNS Display Bold 12',
    align  = 'center',
    valign = 'bottom',
    ellipsize = 'end',
    widget = wibox.widget.textbox
  },
  layout = wibox.layout.flex.horizontal
}
function getTitle()
  awful.spawn.easy_async_with_shell('playerctl metadata xesam:title', function( stdout )
    if (stdout:match("%W")) then
      musicTitle.title:set_text(stdout)
    else
      musicTitle.title:set_text("No active music player found.")
    end
  end)
end

-- Music Artist
local musicArtist =
  wibox.widget {
  {
    id = 'artist',
    font = 'SFNS Display 9',
    align  = 'center',
    valign = 'top',
    widget = wibox.widget.textbox
  },
  layout = wibox.layout.flex.horizontal
}
function getArtist()
  awful.spawn.easy_async_with_shell('playerctl metadata xesam:artist', function( stdout )
    if (stdout:match("%W")) then
      musicArtist.artist:set_text(stdout)
    else
      musicArtist.artist:set_text("Try and play some music :)")
    end
  end)
end



local musicInfo =
  wibox.widget {
    wibox.container.margin(musicTitle, dpi(15), dpi(15)),
    wibox.container.margin(musicArtist, dpi(15), dpi(15)),
    layout = wibox.layout.flex.vertical,
}

return musicInfo

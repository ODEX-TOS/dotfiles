local awful = require('awful')
local naughty = require('naughty')
local watch = require('awful.widget.watch')
local wibox = require('wibox')
local clickable_container = require('widget.material.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi

local PATH_TO_ICONS =  '/etc/xdg/awesome/widget/xdg-folders/icons/'

local trashWidget =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local trash_button = clickable_container(wibox.container.margin(trashWidget, dpi(8), dpi(8), dpi(8), dpi(8)))
trash_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn.easy_async_with_shell("xdg-open trash://", function(stderr) end, 1)
      end
    )
  )
)

-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
awful.tooltip(
  {
    objects = {trash_button},
    mode = 'outside',
    align = 'right',
    timer_function = function()
      return 'Trash'
    end,
    preferred_positions = {'right', 'left', 'top', 'bottom'}
  }
)

trashWidget.icon:set_image(PATH_TO_ICONS .. 'user-trash-full' .. '.svg')

return trash_button
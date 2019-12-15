local beautiful = require('beautiful')
local gears = require('gears')
local awful = require('awful')
local wibox = require('wibox')

local naughty = require('naughty')
local dpi = require('beautiful').xresources.apply_dpi

local clickable_container = require('widget.material.clickable-container')

local icons = require('theme.icons')

local mat_list_item = require('widget.material.list-item')

local apps = require('configuration.apps')
local config = require('config')

local height = dpi(200)
local width = dpi(380)

local icon = "/etc/xdg/awesome/widget/about/icons/info.svg"


screen.connect_signal("request::desktop_decoration", function(s)
    -- Create the box
    local offsetx = dpi(500)
    local padding = dpi(10)
    aboutPage = wibox
    {
      bg = '#00000000',
      visible = false,
      ontop = true,
      type = "normal",
      height = height,
      width = width,
      x = s.geometry.width/2 - (width/2),
      y = s.geometry.height/2 - (height/2),
    }

  aboutBackdrop = wibox {
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
            aboutBackdrop.visible = false
            aboutPage.visible = false
            print("About Closing")
          end
      },
  },
  -- Note that it is using the key name and not the modifier name.
  stop_key           = 'Escape',
  stop_event         = 'release',
}

function toggleAbout()
  aboutBackdrop.visible = not aboutBackdrop.visible
  aboutPage.visible = not aboutPage.visible
  if aboutPage.visible then
    grabber:start()
  else
    grabber:stop()
  end
end

aboutBackdrop:buttons(
  awful.util.table.join(
    awful.button(
      {},
      1,
      function()
        toggleAbout()
      end
    )
  )
)

local widget =
  wibox.widget {
  {
    id = 'icon',
    image = icon,
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local browserWidget =
  wibox.widget {
  {
    id = 'icon',
    image = icons.logo,
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local widget_button = clickable_container(wibox.container.margin(widget, dpi(14), dpi(14), dpi(6), dpi(6)))
widget_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        toggleAbout()
      end
    )
  )
)

local browserOpen = clickable_container(browserWidget, dpi(8), dpi(8), dpi(8), dpi(8))
browserOpen:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        print("Opening website")
        awful.spawn.easy_async_with_shell("$BROWSER tos.pbfp.xyz")
        toggleAbout()
        naughty.notify({ title = "TOS website", message = "Opened the tos homepage", timeout = 5, position = "top_right"})
      end
    )
  )
)

aboutPage:setup {
  expand = "none",
    {
        browserOpen,
        wibox.widget {
            text = config.aboutText,
            font = 'Iosevka Regular 10',
            align = 'center',
            widget = wibox.widget.textbox,
        },
      layout = wibox.layout.fixed.horizontal,
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

return widget_button

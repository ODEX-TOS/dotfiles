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
local beautiful = require('beautiful')
local wibox = require('wibox')
local TaskList = require('widget.task-list')
local gears = require('gears')
local clickable_container = require('widget.material.clickable-container')
local mat_icon_button = require('widget.material.icon-button')
local mat_icon = require('widget.material.icon')
local hardware = require('helper.hardware-check')

local dpi = require('beautiful').xresources.apply_dpi

local icons = require('theme.icons')

  -- Clock / Calendar 12h format
local textclock = wibox.widget.textclock('<span font="Roboto bold 10">%l:%M %p</span>')

  -- Clock / Calendar 12AM/PM fornat
  -- local textclock = wibox.widget.textclock('<span font="Roboto Mono bold 11">%I\n%M</span>\n<span font="Roboto Mono bold 9">%p</span>')
  -- textclock.forced_height = 56
local clock_widget = wibox.container.margin(textclock, dpi(0), dpi(0))

local function rounded_shape(size, partial)
  if partial then
      return function(cr, width, height)
                 gears.shape.partially_rounded_rect(cr, width, height,
                      false, true, false, true, 5)
             end
  else
      return function(cr, width, height)
                 gears.shape.rounded_rect(cr, width, height, size)
             end
  end
end

local function show_widget_or_default(widget, show)
  if show then
    return widget
  end
  return wibox.widget {
		text = '',
		visible = false,
    widget = wibox.widget.textbox
  }
end

-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one

awful.tooltip(
  {
    objects = {clock_widget},
    mode = 'outside',
    align = 'right',
    timer_function = function()
      return os.date("The date today is %B %d, %Y (%A).")
    end,
    preferred_positions = {'right', 'left', 'top', 'bottom'},
    margin_leftright = dpi(8),
    margin_topbottom = dpi(8)
  }
)


local cal_shape = function(cr, width, height)
    gears.shape.infobubble(cr, width, height, 12)
end

-- Calendar Widget
local month_calendar = awful.widget.calendar_popup.month({
	start_sunday = false,
	spacing = 10,
	font = 'Iosevka Custom 11',
	long_weekdays = false,
	margin = 5,
	style_month = { border_width = 0, padding = 12, shape = cal_shape, padding = 25},
	style_header = { border_width = 0, bg_color = '#00000000'},
	style_weekday = { border_width = 0, bg_color = '#00000000' },
	style_normal = { border_width = 0, bg_color = '#00000000', shape = rounded_shape(5)},
	style_focus = { 
    border_width = 0, 
    bg_color = beautiful.primary.hue_500,
    shape        = rounded_shape(5)
  },

	})
	month_calendar:attach( clock_widget, "tc" , { on_pressed = true, on_hover = false })
  
  month_calendar:connect_signal("mouse::leave", function()
    month_calendar:toggle()
  end)


awful.screen.connect_for_each_screen(function(s)
  s.systray = wibox.widget.systray()
  s.systray.visible = false
  s.systray:set_horizontal(true)
  s.systray:set_base_size(28)
  beautiful.systray_icon_spacing = 24
  s.systray.opacity = 0.3
end)

--[[
-- Systray Widget
local systray = wibox.widget.systray()
	systray:set_horizontal(true)
	systray:set_base_size(28)
	beautiful.systray_icon_spacing = 24
	opacity = 0
]]--

local add_button = mat_icon_button(mat_icon(icons.plus, dpi(16))) -- add button -- 24
add_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        awful.spawn(
          awful.screen.focused().selected_tag.defaultApp,
          {
            tag = _G.mouse.screen.selected_tag,
            placement = awful.placement.bottom_right
          }
        )
      end
    )
  )
)


local TopPanel = function(s, offset, controlCenterOnly)
  local offsetx = 0
  if offset == true then
    offsetx = dpi(45) -- 48
  end
  local panel =
    wibox(
    {
      ontop = true,
      screen = s,
      height = dpi(26), -- 48
      width = s.geometry.width - offsetx,
      x = s.geometry.x + offsetx,
      y = s.geometry.y,
      stretch = false,
      bg = beautiful.background.hue_800,
      fg = beautiful.fg_normal,
      struts = {
        top = dpi(26) -- 48
      }
    }
  )

  panel:struts(
    {
      top = dpi(26) -- 48
    }
  )

  panel:setup {
	expand = "none",
    layout = wibox.layout.align.horizontal,
    {
      layout = wibox.layout.fixed.horizontal,
      -- Create a taglist widget
      require('widget.control-center'),
      TaskList(s),
      add_button
    },
	  -- Create a clock widget
	  -- Clock
	  clock_widget,
    {
      layout = wibox.layout.fixed.horizontal,
      -- System tray and widgets
      --wibox.container.margin(systray, dpi(14), dpi(14)),
      wibox.container.margin(s.systray, dpi(14), dpi(0), dpi(4), dpi(4)),
      show_widget_or_default(require('widget.battery')(), hardware.hasBattery()),
      show_widget_or_default(require('widget.bluetooth'), hardware.hasBluetooth()),
      show_widget_or_default(require('widget.wifi'), hardware.hasWifi()),
      require('widget.package-updater'),
      show_widget_or_default(require('widget.music'),hardware.hasSound()), --only add this when the data can be extracted from spotify
      require('widget.about'),
      show_widget_or_default(require('widget.screen-recorder')(), hardware.hasFFMPEG()),
      require('widget.search'),
      require('widget.notification-center'),
    }
  }
  if controlCenterOnly then
    return require('widget.control-center')
  end

  return panel
end

return TopPanel

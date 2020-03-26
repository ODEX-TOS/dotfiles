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
local apps = require('configuration.apps')
local dpi = require('beautiful').xresources.apply_dpi

local left_panel = function(screen)
  local action_bar_width = dpi(45) -- 48
  local panel_content_width = dpi(400)

  local panel =
    wibox {
    screen = screen,
    width = action_bar_width,
    height = screen.geometry.height,
    x = screen.geometry.x,
    y = screen.geometry.y,
    ontop = true,
    bg = beautiful.background.hue_800,
    fg = beautiful.fg_normal
  }
  _G.left_panel = panel
  panel.opened = false

  panel:struts(
    {
      left = action_bar_width
    }
  )

  local backdrop =
    wibox {
    ontop = true,
    screen = screen,
    bg = '#00000000',
    type = 'dock',
    x = screen.geometry.x,
    y = screen.geometry.y,
    width = screen.geometry.width,
    height = screen.geometry.height
  }

  local action_grabber = awful.keygrabber {
    keybindings = {
        awful.key {
            modifiers = {},
            key       = 'Escape',
            on_press  = function()
              panel:close()
            end
        },
    },
    -- Note that it is using the key name and not the modifier name.
    stop_key           = 'Escape',
    stop_event         = 'release',
  }

  function panel:run_rofi()
    action_grabber:stop()
    _G.awesome.spawn(
      apps.default.web,
      false,
      false,
      false,
      false,
      function()
        panel:toggle()
      end
    )
  end

  function panel:run_dpi()
    action_grabber:stop()
    _G.awesome.spawn(
      apps.default.rofidpimenu,
      false,
      false,
      false,
      false,
      function()
        panel:toggle()
      end
    )
  end

  function panel:run_wifi()
    action_grabber:stop()
    _G.awesome.spawn(
      apps.default.rofiwifimenu,
      false,
      false,
      false,
      false,
      function()
        panel:toggle()
      end
    )
  end

  local openPanel = function(should_run_rofi)
    panel.width = action_bar_width + panel_content_width
    backdrop.visible = true
    panel.visible = false
    panel.visible = true
    panel:get_children_by_id('panel_content')[1].visible = true
    if should_run_rofi then
      panel:run_rofi()
    end
    action_grabber:start()
    panel:emit_signal('opened')
  end

  local closePanel = function()
    panel.width = action_bar_width
    panel:get_children_by_id('panel_content')[1].visible = false
    backdrop.visible = false
    action_grabber:stop()
    panel:emit_signal('closed')
  end

  function panel:toggle(should_run_rofi)
    self.opened = not self.opened
    if self.opened then
      openPanel(should_run_rofi)
    else
      closePanel()
    end
  end

  function panel:close()
      self.opened = false
      closePanel()
  end

  backdrop:buttons(
    awful.util.table.join(
      awful.button(
        {},
        1,
        function()
          panel:toggle()
        end
      )
    )
  )

  panel:setup {
    layout = wibox.layout.align.horizontal,
    nil,
    {
      id = 'panel_content',
      bg = beautiful.background.hue_800 .. '66', -- Background color of Dashboard
      widget = wibox.container.background,
      visible = false,
      forced_width = panel_content_width,
      {
        require('layout.left-panel.dashboard')(screen, panel),
        layout = wibox.layout.stack
      }
    },
    require('layout.left-panel.action-bar')(screen, panel, action_bar_width)
  }
  return panel
end

return left_panel

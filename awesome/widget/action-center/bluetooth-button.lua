--[[
--MIT License
--
--Copyright (c) 2019 PapyElGringo
--Copyright (c) 2019 Tom Meyers
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
local naughty = require('naughty')
local wibox = require('wibox')
local clickable_container = require('widget.action-center.clickable-container')
local gears = require('gears')
local dpi = require('beautiful').xresources.apply_dpi
local watch = require('awful.widget.watch')
local mat_list_item = require('widget.material.list-item')

local HOME = os.getenv('HOME')
local PATH_TO_ICONS = HOME .. '/.config/awesome/widget/action-center/icons/'
local checker
local mode


local widget =
  wibox.widget {
  {
    id = 'icon',
    widget = wibox.widget.imagebox,
    resize = true
  },
  layout = wibox.layout.align.horizontal
}

local function update_icon()
  local widgetIconName
  if(mode == true) then
    widgetIconName = 'toggled-on'
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
  else
    widgetIconName = 'toggled-off'
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
  end
end

local function check_bluetooth()
  awful.spawn.easy_async_with_shell('bluetoothctl show', function( stdout )
    checker = stdout:match('Powered: yes')
    -- IF NOT NULL THEN WIFI IS DISABLED
    -- IF NULL IT THEN WIFI IS ENABLED
    if(checker ~= nil) then
      mode = false
      --awful.spawn('notify-send checker~=NOTNULL disabled')
      update_icon()
    else
      mode = true
    --awful.spawn('notify-send checker==NULL enabled')
      update_icon()
    end
  end)

end


local function toggle_bluetooth()
  if(mode == true) then
    awful.spawn('tos bluetooth set off')
    awful.spawn("notify-send 'Bluetooth device disabled'")
    mode = false
    update_icon()
  else
    awful.spawn('tos bluetooth set on')
    awful.spawn("notify-send 'Initializing Bluetooth Service' 'Enable in System Tray'")
    mode = true
    update_icon()
  end

end


check_bluetooth()



local bluetooth_button = clickable_container(wibox.container.margin(widget, dpi(7), dpi(7), dpi(7), dpi(7))) -- 4 is top and bottom margin
bluetooth_button:buttons(
  gears.table.join(
    awful.button(
      {},
      1,
      nil,
      function()
        toggle_bluetooth()
      end
    )
  )
)

-- Alternative to naughty.notify - tooltip. You can compare both and choose the preferred one
awful.tooltip(
  {
    objects = {bluetooth_button},
    mode = 'outside',
    align = 'right',
    timer_function = function()
      if checker == nil then
        return 'Bluetooth Enabled'
      else
        return 'Bluetooth Disabled'
      end
    end,
    preferred_positions = {'right', 'left', 'top', 'bottom'}
  }
)

local last_wifi_check = os.time()
watch(
  'bluetoothctl show',
  5,
  function(_, stdout)
   -- Check if there  bluetooth
    checker = stdout:match('Powered: no') -- If 'Controller' string is detected on stdout
    local widgetIconName
    if (checker == nil) then
      widgetIconName = 'toggled-on'
    else
      widgetIconName = 'toggled-off'
    end
    widget.icon:set_image(PATH_TO_ICONS .. widgetIconName .. '.svg')
    collectgarbage('collect')
  end,
  widget
)

local settingsName = wibox.widget {
  text = 'Bluetooth Connection',
  font = 'Iosevka Regular 10',
  align = 'left',
  widget = wibox.widget.textbox
}

local content =   wibox.widget {
    settingsName,
    bluetooth_button,
    bg = '#ffffff20',
    shape = gears.shape.rounded_rect,
    widget = wibox.container.background(settingsName),
    layout = wibox.layout.ratio.horizontal,

  }
content:set_ratio(1, .85)

local bluetoothButton =  wibox.widget {
  wibox.widget {
    content,
    widget = mat_list_item
  },
  layout = wibox.layout.fixed.vertical
}
return bluetoothButton
--return bluetooth_button

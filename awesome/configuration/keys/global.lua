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
require('awful.autofocus')
local beautiful = require('beautiful')
local hotkeys_popup = require('awful.hotkeys_popup').widget

local modkey = require('configuration.keys.mod').modKey
local altkey = require('configuration.keys.mod').altKey
local apps = require('configuration.apps')
-- Key bindings
local globalKeys =
  awful.util.table.join(
  -- Hotkeys
  awful.key({modkey}, 'F1', hotkeys_popup.show_help, {description = 'show help', group = 'awesome'}),
  -- Custom Keys
  awful.key(
    {modkey}, 'Return',
    function()
      awful.spawn(apps.default.terminal)
    end,
    { description = "Open Terminal", group = "launcher"}),

    awful.key(
      {modkey}, 'd',
      function()
        awful.util.spawn(apps.default.rofiappmenu)
      end,
      { description = "Open Rofi", group = "launcher"}),

  awful.key(
    {modkey, "Shift"}, 'w',
    function()
      awful.spawn("firefox-developer-edition")
    end,
    { description = "Open Browser", group = "launcher"}),

  awful.key(
    {modkey, "Shift"}, 'e',
    function()
      awful.spawn("nemo")
    end,
    { description = "Open file manager", group = "launcher"}),

  awful.key(
    {"Control", "Shift"}, 'Escape',
    function()
      awful.spawn("gnome-system-monitor")
    end,
    { description = "Open system monitor", group = "launcher"}),


  -- Screen Shots
  -- Screen Shot and Save
  awful.key({ }, "Print", function () awful.util.spawn("snap full") end),

  -- Screen Shot Area and Save
  awful.key({modkey, "Shift"}, 's', function () awful.util.spawn("snap area") end),

  -- Toggle System Tray
  awful.key({ modkey }, '=', function ()
      awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible
    end, {description = "Toggle systray visibility", group = "custom"}),

  -- Tag browsing
  awful.key({modkey}, 'w', awful.tag.viewprev, {description = 'view previous', group = 'tag'}),
  awful.key({modkey}, 's', awful.tag.viewnext, {description = 'view next', group = 'tag'}),
  awful.key({modkey}, 'Escape', awful.tag.history.restore, {description = 'go back', group = 'tag'}),
  -- Default client focus
  awful.key(
    {modkey},
    'd',
    function()
      awful.client.focus.byidx(1)
    end,
    {description = 'focus next by index', group = 'client'}
  ),
  awful.key(
    {modkey},
    'a',
    function()
      awful.client.focus.byidx(-1)
    end,
    {description = 'focus previous by index', group = 'client'}
  ),
  awful.key(
    {modkey},
    'e',
    function()
      _G.screen.primary.left_panel:toggle(true)
    end,
    {description = 'show main menu', group = 'awesome'}
  ),
  awful.key({modkey}, 'u', awful.client.urgent.jumpto, {description = 'jump to urgent client', group = 'client'}),
  awful.key(
    {modkey},
    'Tab',
    function()
      awful.client.focus.history.previous()
      if _G.client.focus then
        _G.client.focus:raise()
      end
    end,
    {description = 'go back', group = 'client'}
  ),
  -- Programms
  awful.key(
    {modkey},
    'l',
    function()
      awful.spawn(apps.default.lock)
    end
  ),
  --[[
  awful.key(
    {},
    'Print',
    function()
      awful.util.spawn_with_shell('maim -s | xclip -selection clipboard -t image/png')
    end
  ),]]
  -- Standard program
  awful.key({modkey, 'Control'}, 'r', _G.awesome.restart, {description = 'reload awesome', group = 'awesome'}),
  awful.key({modkey, 'Control'}, 'q', _G.awesome.quit, {description = 'quit awesome', group = 'awesome'}),
  awful.key(
    {altkey, 'Shift'},
    'l',
    function()
      awful.tag.incmwfact(0.05)
    end,
    {description = 'increase master width factor', group = 'layout'}
  ),
  awful.key(
    {altkey, 'Shift'},
    'h',
    function()
      awful.tag.incmwfact(-0.05)
    end,
    {description = 'decrease master width factor', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Shift'},
    'h',
    function()
      awful.tag.incnmaster(1, nil, true)
    end,
    {description = 'increase the number of master clients', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Shift'},
    'l',
    function()
      awful.tag.incnmaster(-1, nil, true)
    end,
    {description = 'decrease the number of master clients', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Control'},
    'h',
    function()
      awful.tag.incncol(1, nil, true)
    end,
    {description = 'increase the number of columns', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Control'},
    'l',
    function()
      awful.tag.incncol(-1, nil, true)
    end,
    {description = 'decrease the number of columns', group = 'layout'}
  ),
  awful.key(
    {modkey},
    'space',
    function()
      awful.layout.inc(1)
    end,
    {description = 'select next', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Shift'},
    'space',
    function()
      awful.layout.inc(-1)
    end,
    {description = 'select previous', group = 'layout'}
  ),
  awful.key(
    {modkey, 'Control'},
    'n',
    function()
      local c = awful.client.restore()
      -- Focus restored client
      if c then
        _G.client.focus = c
        c:raise()
      end
    end,
    {description = 'restore minimized', group = 'client'}
  ),
  -- Dropdown application
  awful.key(
    {modkey},
    '`',
    function()
      _G.toggle_quake()
    end,
    {description = 'dropdown application', group = 'launcher'}
  ),
  -- Widgets popups
  awful.key(
    {altkey},
    'h',
    function()
      if beautiful.fs then
        beautiful.fs.show(7)
      end
    end,
    {description = 'show filesystem', group = 'widgets'}
  ),
  awful.key(
    {altkey},
    'w',
    function()
      if beautiful.weather then
        beautiful.weather.show(7)
      end
    end,
    {description = 'show weather', group = 'widgets'}
  ),
  -- Brightness
  awful.key(
    {},
    'XF86MonBrightnessUp',
    function()
      if (_G.oled) then
        awful.spawn('brightness -a 5 -F')
      else
        awful.spawn('brightness -s 100 -F') -- reset pixel values when using backlight
        awful.spawn('brightness -a 5')
      end
      if toggleBriOSD ~= nil then
        _G.toggleBriOSD(true)
      end
      if UpdateBrOSD ~= nil then
        _G.UpdateBrOSD()
      end
    end,
    {description = '+10%', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86MonBrightnessDown',
    function()
      if (_G.oled) then
        awful.spawn('brightness -d 5 -F')
      else
        awful.spawn('brightness -s 100 -F') -- reset pixel values when using backlight
        awful.spawn('brightness -d 5')
      end
      if toggleBriOSD ~= nil then
        _G.toggleBriOSD(true)
      end
      if UpdateBrOSD ~= nil then
        _G.UpdateBrOSD()
      end
    end,
    {description = '-10%', group = 'hotkeys'}
  ), 
  -- ALSA volume control
  awful.key(
    {},
    'XF86AudioRaiseVolume',
    function()
      awful.spawn('amixer -D pulse sset Master 5%+')
      if toggleVolOSD ~= nil then
        _G.toggleVolOSD(true)
      end
      if UpdateVolOSD ~= nil then
        _G.UpdateVolOSD()
      end
    end,
    {description = 'volume up', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioLowerVolume',
    function()
      awful.spawn('amixer -D pulse sset Master 5%-')
      if toggleVolOSD ~= nil then
        _G.toggleVolOSD(true)
      end
      if UpdateVolOSD ~= nil then
        _G.UpdateVolOSD()
      end
    end,
    {description = 'volume down', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioMute',
    function()
      awful.spawn('amixer -D pulse set Master 1+ toggle')
      if toggleVolOSD ~= nil then
        _G.toggleVolOSD(true)
      end
      if UpdateVolOSD ~= nil then
        _G.UpdateVolOSD()
      end
    end,
    {description = 'toggle mute', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86AudioNext',
    function()
      print("Pressed Audio Next")
    end,
    {description = 'toggle mute', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86PowerDown',
    function()
      _G.exit_screen_show()

    end,
    {description = 'toggle exit screen', group = 'hotkeys'}
  ),
  awful.key(
    {},
    'XF86PowerOff',
    function()
      _G.exit_screen_show()
    end,
    {description = 'toggle exit screen', group = 'hotkeys'}
  )
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
  -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
  local descr_view, descr_toggle, descr_move, descr_toggle_focus
  if i == 1 or i == 9 then
    descr_view = {description = 'view tag #', group = 'tag'}
    descr_toggle = {description = 'toggle tag #', group = 'tag'}
    descr_move = {description = 'move focused client to tag #', group = 'tag'}
    descr_toggle_focus = {description = 'toggle focused client on tag #', group = 'tag'}
  end
  globalKeys =
    awful.util.table.join(
    globalKeys,
    -- View tag only.
    awful.key(
      {modkey},
      '#' .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          tag:view_only()
        end
      end,
      descr_view
    ),
    -- Toggle tag display.
    awful.key(
      {modkey, 'Control'},
      '#' .. i + 9,
      function()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
          awful.tag.viewtoggle(tag)
        end
      end,
      descr_toggle
    ),
    -- Move client to tag.
    awful.key(
      {modkey, 'Shift'},
      '#' .. i + 9,
      function()
        if _G.client.focus then
          local tag = _G.client.focus.screen.tags[i]
          if tag then
            _G.client.focus:move_to_tag(tag)
          end
        end
      end,
      descr_move
    ),
    -- Toggle tag on focused client.
    awful.key(
      {modkey, 'Control', 'Shift'},
      '#' .. i + 9,
      function()
        if _G.client.focus then
          local tag = _G.client.focus.screen.tags[i]
          if tag then
            _G.client.focus:toggle_tag(tag)
          end
        end
      end,
      descr_toggle_focus
    )
  )
end

return globalKeys

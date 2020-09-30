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
local awful = require("awful")
local wibox = require("wibox")

-- @param show            : the widget to make scrollable
-- @param speed           : the speed at which to make the fade effect go slower (a smaller value = faster slowdown)
-- @param offset          : the initial offset at the top
-- @param fps             : how fast to update the scrolling effect. A lower fps is better for performance
-- @param bTopToBottom    : should the scrolling happen left to right or top to bottom
-- @param bIsInverted     : Should the movement be inverted
-- @param max_scroll      : The height of the widget until we stop scrolling
return function(show, speed, offset, fps, bTopToBottom, bIsInverted, max_scroll)
    offset = offset or 0
    local speed = speed or 3
    local bTopToBottom = bTopToBottom or true
    local bIsInverted = bIsInverted or false
    local max_scroll = max_scroll or 90000 -- if no max scrolling is present we set it to the max

    deltax = 0
    deltay = 0

    local widget = nil
    local size = 20
    -- connect signals to get the current status of the scrollbar
    show:connect_signal(
        "mouse::enter",
        function()
            entered = true
            pressed = false -- if one leaves the widget while holding the button this will prevent that
        end
    )

    show:connect_signal(
        "mouse::leave",
        function()
            entered = false
        end
    )
    show:connect_signal(
        "button::press",
        function()
            pressed = true
        end
    )

    show:connect_signal(
        "button::release",
        function()
            pressed = false
        end
    )
    -- end gathering connection details

    function updateCoords()
        prevx = mouse.coords().x
        prevy = mouse.coords().y
    end

    -- Move the prevx and prevy values closer to zero on each iteration
    function reset()
        deltax = deltax - (deltax / speed)
        deltay = deltay - (deltay / speed)
        move()
        prevx = nil
        prevy = nil
    end

    function move()
        if (bTopToBottom) then
            offset = offset + deltay
        else
            offset = offset + deltax
        end
        if (bIsInverted) then
            if (offset < 0) then
                offset = 0
            end
            if (bTopToBottom) then
                widget.top = -offset
            else
                widget.left = -offset
            end
        else
            if (offset > 0) then
                offset = 0
            end
            if (offset < -max_scroll) then
                offset = -max_scroll
            end
            if (bTopToBottom) then
                widget.top = offset
            else
                widget.left = offset
            end
        end
    end

    for s in screen do
        if ((s.geometry.height / 50) > size) then
            size = (s.geometry.height / 50)
        end
    end

    widget = wibox.container.margin(show)
    widget:buttons(
        awful.util.table.join(
            awful.button(
                {},
                4,
                function(t)
                    if (bTopToBottom) then
                        if ((offset + size) > 0) then
                            offset = 0
                        else
                            offset = offset + size
                        end
                        widget.top = offset
                    end
                    bAddingSize = true
                end
            ),
            awful.button(
                {},
                5,
                function(t)
                    if (bTopToBottom) then
                        if (offset - 20 < -max_scroll) then
                            offset = -max_scroll
                        else
                            offset = offset - size
                        end
                        widget.top = offset
                    end
                    bAddingSize = false
                end
            )
        )
    )
    return widget
end

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

local capi      = { client = client }
local wibox     = require( "wibox"         )
local beautiful = require( "beautiful"     )
local awful     = require( "awful"         )
local surface   = require( "gears.surface" )
local shape     = require( "gears.shape"   )
local mat_color    = require("theme.mat-colors")
local config       = require( "theme.config"   ) 

local arrow_color = mat_color[config["accent"]].hue_500 or mat_color.cyan.hue_800
local bg_color = mat_color[config["primary"]].hue_700 or mat_color.purple.hue_800

function color(value)
  if value == nil then return nil end
  return "#" .. value
end


arrow_color = color(config["accent_hue_500"]) or arrow_color
bg_color = color(config["primary_hue_700"]) or bg_color


local module,indicators,cur_c = {},nil,nil

local values = {"top"     , "top_right"  , "right" ,  "bottom_right" ,
                "bottom"  , "bottom_left", "left"  ,  "top_left"     }

local invert = {
  left  = "right",
  right = "left" ,
  up    = "down" ,
  down  = "up"   ,
}

local r_ajust = {
    left  = function(c, d) return { x      = c.x      - d, width = c.width   + d } end,
    right = function(c, d) return { width  = c.width  + d,                       } end,
    up    = function(c, d) return { y      = c.y      - d, height = c.height + d } end,
    down  = function(c, d) return { height = c.height + d,                       } end,
}

local function create_indicators()
    local ret     = {}
    local angle   = -((2*math.pi)/8)

    -- Get the parameters
    local size    = beautiful.collision_resize_width or 40
    local s       = beautiful.collision_resize_shape or shape.circle
    local bw      = beautiful.collision_resize_border_width
    local bc      = beautiful.collision_resize_border_color
    local padding = beautiful.collision_resize_padding or 7
    local bg      = bg_color or "#ff0000"
    local fg      = arrow_color or "#0000ff"

    for k,v in ipairs(values) do
        local w = wibox {
            width   = size,
            height  = size,
            ontop   = true,
            visible = true
        }

        angle = angle + (2*math.pi)/8

        local tr = (size - 2*padding) / 2

        w:setup {
            {
                {
                    {
                        widget = wibox.widget.imagebox
                    },
                    shape = shape.transform(shape.arrow)
                        : translate( tr,tr   )
                        : rotate   ( angle   )
                        : translate( -tr,-tr ),
                    bg     = fg,
                    widget = wibox.container.background
                },
                margins = padding,
                widget  = wibox.container.margin,
            },
            bg                 = bg,
            shape              = s,
            shape_border_width = bw,
            shape_border_color = bc,
            widget             = wibox.container.background
        }

        if awesome.version >= "v4.1" then
            w.shape = s
        else
            surface.apply_shape_bounding(w, s)
        end

        ret[v] = w
    end

    return ret
end

function module.hide()
    if not indicators then return end

    for k,v in ipairs(values) do indicators[v].visible = false end

    if not cur_c then return end

    cur_c:disconnect_signal("property::geometry", module.display)
    cur_c = nil
end

function module.display(c,toggle)
    if type(c) ~= "client" then --HACK
        c = capi.client.focus
    end

    if not c then return end

    indicators = indicators or create_indicators()

    if c ~= cur_c then
        if cur_c then
        cur_c:disconnect_signal("property::geometry", module.display)
        end
        c:connect_signal("property::geometry", module.display)
        cur_c = c
    elseif toggle == true then
        module.hide()
    end

    for k,v in ipairs(values) do
        local w = indicators[v]
        awful.placement[v](w, {parent=c})
        w.visible = true
    end
end

function module.resize(mod,key,event,direction,is_swap,is_max)
    local c = capi.client.focus
    if not c then return true end

    local del = is_swap and -100 or 100
    direction = is_swap and invert[direction] or direction

    c:emit_signal("request::geometry", "mouse.resize", r_ajust[direction](c, del))

    return true
end

-- Always display the arrows when resizing
awful.mouse.resize.add_enter_callback(module.display, "mouse.resize")
awful.mouse.resize.add_leave_callback(module.hide   , "mouse.resize")

return module
-- kate: space-indent on; indent-width 4; replace-tabs on;

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

local wibox = require('wibox')
local mat_list_item = require('widget.material.list-item')
local mat_slider = require('widget.material.slider')
local mat_icon = require('widget.material.icon')
local icons = require('theme.icons')
local watch = require('awful.widget.watch')
local dpi = require('beautiful').xresources.apply_dpi
local config = require('config')
local biggest_upload = 1
local biggest_download = 1

local slider_up =
  wibox.widget {
  read_only = true,
  widget = mat_slider
}

local slider_down =
  wibox.widget {
  read_only = true,
  widget = mat_slider
}

watch(
  "sh /etc/xdg/awesome/net-speed.sh",
  config.network_poll,
  function(_, stdout)
    local upload_text, download_text = stdout:match('(.*);(.*)')
    if upload_text:match('M') then
      up_num = tonumber(upload_text:match('%S+'))
      if up_num > biggest_upload then
        biggest_upload = up_num
      end
      slider_up:set_value((up_num / biggest_upload) * 100)
    else
      up_num = tonumber(upload_text:match('%S+')) / 1000
      slider_up:set_value((up_num / biggest_upload) * 100)
    end

    if download_text:match('M') then
      down_num = tonumber(download_text:match('%S+'))
      if down_num > biggest_download then
        biggest_download = down_num
      end
      slider_down:set_value((down_num / biggest_download) * 100)
    else
      down_num = tonumber(download_text:match('%S+')) / 1000
      slider_down:set_value((down_num / biggest_upload) * 100)
    end
    collectgarbage('collect')
  end
)

local network_meter_upload =
wibox.widget {
  wibox.widget {
    icon = icons.upload,
    size = dpi(24),
    widget = mat_icon
  },
  slider_up,
  widget = mat_list_item
}

local network_meter_download =
  wibox.widget {
    wibox.widget {
      icon = icons.download,
      size = dpi(24),
      widget = mat_icon
    },
    slider_down,
    widget = mat_list_item
}

function meter(bisUpload)
  if bisUpload then
    return network_meter_upload
  end
  return network_meter_download
end

return meter

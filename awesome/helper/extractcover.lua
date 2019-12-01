-- Extract album cover from song
-- Will used by music/mpd widget
-- Depends ffmpeg or perl-image-exiftool, song with hard-coded album cover

local awful = require('awful')

local extract = {}
-- TODO: get image information from spotify
local extract_cover = function()
  local extract_script = [[
    if [[ "$(playerctl status)" == "Playing" \]\]; then
      url=$(playerctl -p spotify metadata mpris:artUrl)
      if [ "$url" ]; then
        curl -fL "$url" -o /tmp/cover.jpg
      fi
    fi
  ]]

  awful.spawn.easy_async_with_shell(extract_script, function(stderr) end, false)
end


extractit = function()
  extract_cover()
end

extract.extractalbum = extractit

return extract


local mode = require('parser')(os.getenv('HOME') .. "/.config/tos/general.conf")["audio_change_sound"] or "1"
local spawn = require('awful.spawn')

local function play_sound()
    if mode == "1" then
      spawn('paplay /etc/xdg/awesome/sound/audio-pop.wav')
    end
end

return play_sound
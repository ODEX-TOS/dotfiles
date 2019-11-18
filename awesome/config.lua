
-- This file holds general configuration parameters and functions you can use
local HOME = os.getenv('HOME')
local filesystem = require('gears.filesystem')

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

config = {
    package_timeout = 60, -- how frequently we want to check if there are new updates in seconds
    battery_timeout = 1, -- How frequently we want to check our battery status in seconds
    colors_config = HOME .. "/.config/tos/colors.conf",
    icons_config = HOME .. "/.config/tos/icons.conf",
    getComptonFile = function ()
        userfile = HOME .. "/.config/compton.conf"
        if(file_exists(userfile)) then
            return userfile
        end
        return filesystem.get_configuration_dir() .. '/configuration/compton.conf '
    end
}


return config

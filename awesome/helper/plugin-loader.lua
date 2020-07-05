-- This file load plugins from the .config/tde/*/init.lua files
-- Usage in lua is require("plugin-dir-name")
-- End users should add their plugins in that directory
-- Following that there is a plugins.conf file inside .config/tos/plugins.conf
-- This file describes which plugins should be loaded
local dirExists = require('helper.file').dir_exists
local naughty = require("naughty")

function getItem(item)
    return plugins[item] or nil
end

function getPluginSection(section)
    local section = section .. "_"
    local iterator = {}
    local i = 0
    while true do
        i = i + 1
        name = section .. i
        if getItem(name) ~= nil then
            -- only require plugin if it exists
            -- otherwise the user entered a wrong pluging
            -- system plugins are also accepted and start with widget.
            if getItem(name):find("^widget.") or dirExists(os.getenv('HOME') .. "/.config/tde/" .. getItem(name))  then
                table.insert(iterator, require(getItem(name)))
                print("Plugin " .. name .. " is loaded in!")
            else
                print("Plugin " .. name .. " is not valid!")
                -- notify the user that a wrong plugin was entered
                naughty.notify({ text = 'Plugin <span weight="bold">' .. name .."</span> not found. Make sure it is present in  ~/.config/tde/" .. name .. "/init.lua",
                                 timeout = 5,
                                 screen = mouse.screen,
                                 urgency = "critical",
                                 })
            end
        else 
        return iterator
        end
    end
end

return getPluginSection


local awful = require("awful")
local filehandle = require("helper.file")
-- store the old print variable into echo
echo = print

-- color coded log messages
LOG_ERROR="\27[0;31m[ ERROR "
LOG_WARN="\27[0;33m[ WARN "
LOG_DEBUG="\27[0;35m[ DEBUG "
LOG_INFO="\27[0;32m[ INFO "


local dir = os.getenv("HOME") .. "/.cache/tde"
local filename = dir .. "/stdout.log"

-- create the tde directory
if not filehandle.dir_exists(dir) then
	io.popen("mkdir -p " .. dir)
end

-- open the log file (if no handle exists already)

-- overwrite the print function call to enable easier debugging
print = function (arg, log_type)
	local file = io.open(filename, "a")

	awful.spawn.easy_async_with_shell("date +%H:%M:%S.$(($(date +%N)/1000000))", function(out)
		log = log_type or LOG_INFO
		statement = log .. out:gsub("\n", "") .. " ]\27[0m "
		for line in arg:gmatch("[^\r\n]+") do
			-- print it to stdout
			echo(statement .. line)
			-- append it to the log file
			file:write(statement .. line .. "\n")
		end
		file:close()
	end)
end

return {
	warn = LOG_WARN,
	error = LOG_ERROR,
	debug = LOG_DEBUG,
	info = LOG_INFO
}

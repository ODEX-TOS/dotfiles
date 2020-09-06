

local awful = require("awful")
local filehandle = require("helper.file")
local time = require("socket").gettime
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

	log = log_type or LOG_INFO
	local out = os.date("%H:%M:%S") .. "." .. math.floor(time() * 10000) % 10000
	statement = log .. out:gsub("\n", "") .. " ]\27[0m "
	for line in arg:gmatch("[^\r\n]+") do
		-- print it to stdout
		echo(statement .. line)
		-- append it to the log file
		file:write(statement .. line .. "\n")
	end
	file:close()
end

return {
	warn = LOG_WARN,
	error = LOG_ERROR,
	debug = LOG_DEBUG,
	info = LOG_INFO
}

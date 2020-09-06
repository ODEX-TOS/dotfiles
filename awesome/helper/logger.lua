

local awful = require("awful")
-- store the old print variable into echo
echo = print

-- color coded log messages
LOG_ERROR="\27[0;31m[ ERROR "
LOG_WARN="\27[0;33m[ WARN "
LOG_DEBUG="\27[0;35m[ DEBUG "
LOG_INFO="\27[0;32m[ INFO "

-- overwrite the print function call to enable easier debugging
print = function (arg, log_type)
	awful.spawn.easy_async_with_shell("date +%H:%M:%S.$(($(date +%N)/1000000))", function(out)
		log = log_type or LOG_INFO
		echo(log .. out:gsub("\n", "") .. " ]\27[0m " .. arg)
	end)
end

return {
	warn = LOG_WARN,
	error = LOG_ERROR,
	debug = LOG_DEBUG,
	info = LOG_INFO
}

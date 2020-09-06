-- This script listens for errors and sends them to sentry.odex.be
-- It is used to debug common errors and make the user experience better
-- Information that is stored by sentry:
--  * username
--  * hostname
--  * TDE version
--  * stack trace of error



local sentrypkg = require('helper.sentry')

local sentry = sentrypkg.new {
    sender = require("helper.sentry.senders.luasocket").new {
        dsn = "https://4684617907b540c0a3caf0245e1d6a2a@sentry.odex.be/6"
    },
    logger = "TDE-log",
    tags = { 
        version = awesome.version,
        release = awesome.release,
        hostname = awesome.hostname
     },
}


awesome.connect_signal("debug::error", function (err)
    -- Make sure we don't go into an endless error loop
    if in_error then return end
    in_error = true

    local exception = {{
        ["type"]= "Error",
        ["value"]= tostring(err),
        ["module"]= "tde";
     }}
    sentry:captureException(
        exception,
        {tags = { 
            compositor = awesome.composite_manager_running
        }}
    )
    print("Sending error: " .. tostring(err))
    in_error = false
end)

return sentry
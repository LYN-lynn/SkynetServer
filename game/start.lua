local skynet = require "skynet"
local snax = require "skynet.snax"

skynet.start(function ()
    local ctrl = snax.newservice("main")
    -- local ctrl = snax.newservice("test")
    skynet.newservice("debug_console", 8889)
end)
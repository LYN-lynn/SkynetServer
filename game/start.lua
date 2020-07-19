local skynet = require "skynet"
local snax = require "skynet.snax"

skynet.start(function ()
    snax.newservice("main")
    skynet.newservice("debug_console", 60008)
    -- skynet.newservice("testStart")
end)
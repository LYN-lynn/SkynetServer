local skynet = require "skynet"
local snax = require "skynet.snax"

skynet.start(function ()
    snax.newservice("main")
    snax.newservice("main_http")
    skynet.newservice("debug_console", 8889)
end)
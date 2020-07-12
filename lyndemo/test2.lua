local  skynet = require "skynet"

skynet.start(function ()
    skynet.error("test2 开始")
    skynet.newservice("test")
    skynet.error("test2 结束")
end)
-- 查询是否已经创建了这个服务

local  skynet = require "skynet"

skynet.start(function ()
    -- skynet.uniqueservice("test")
    skynet.newservice("test")
    skynet.error("开始查询test")
    skynet.queryservice(true,"test")
    -- skynet.queryservice("test")
    skynet.error("结束查询test")
end)
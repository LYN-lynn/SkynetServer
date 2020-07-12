local skynet = require "skynet"
require "skynet.manager"

local  queue = require "skynet.queue"
local cs = queue()

skynet.start(function ()
    skynet.register(".queuetest")
    skynet.dispatch("lua",function (session, address, ...)
        local msg = {...}
        skynet.error("接收到请求", msg[2])
        skynet.retpack(cs(function ()
            skynet.error("处理 开始", msg[2], " 耗时：", msg[1])
            skynet.sleep(msg[1])
            skynet.error("处理 完毕", msg[2], "END-")
        end))
    end)

    skynet.timeout(10,function ()
        skynet.newservice("test7_11call")
    end)
end)

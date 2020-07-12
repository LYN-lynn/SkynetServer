-- test7.lua
local skynet = require "skynet"
require "skynet.manager"

skynet.start(function ()
    skynet.register(".ser")  -- 当前服务别名

    skynet.timeout(100,function () -- 启动另外一个发送消息的服务
        skynet.error("准备启动 test7_3")
        skynet.newservice("test7_3")
    end)

    skynet.dispatch("lua",function (sesssion, address, ...) -- 注册接收当前服的所有lua类型的消息
        skynet.error("接收到新的消息 ==========")
        local msg = {...}
        for _k,_v in pairs(msg) do
            skynet.error(_k,":",_v)
        end
        skynet.sleep(300)
        skynet.retpack("我收到你的的消息", true) -- retpack应答方式
        skynet.error("接收到新的消息 ===== over")
    end)
end)
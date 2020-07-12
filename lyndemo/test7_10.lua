-- test7_10.lua
local skynet = require "skynet"
require "skynet.manager"

skynet.start(function ()
    skynet.register(".ser")  -- 当前服务别名

    skynet.timeout(50,function () -- 启动另外一个发送消息的服务
        skynet.error("准备启动 test7_8")
        skynet.newservice("test7_8")
    end)

    skynet.dispatch("lua",function (...) -- 注册接收当前服的所有lua类型的消息
        skynet.error("!!!")
        skynet.sleep(200)
    end)
end)

function ResponseFunc(msg, rsp)
    -- local rsp = skynet.response(skynet.pack) -- 注意，rsp不能在这里获取
    skynet.error("接收到新的消息 ==========")
    for _k,_v in pairs(msg) do
        skynet.error(_k,":",_v)
    end

    local sendersession = msg[1]
    local senderaddress = msg[2]
    skynet.sleep(100)
    skynet.kill(".call")

    -- local r = {rsp(true, {"收到了", "第二消息"})}    -- rsp 只能接收两个参数
    local r = {rsp(false, "错误消息")}    -- rsp 只能接收两个参数

    -- local r = {rsp("test", "收到了", "这是test")}    -- rsp 只能接收两个参数
    skynet.error("接收到新的消息 ===== over", #r, ":" ,r[1])
end
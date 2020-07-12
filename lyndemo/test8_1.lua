local skynet = require "skynet"
local mc = require "compat10.multicast"
require "skynet.manager"
local playername = ...

skynet.start(function ()
    local s = skynet.localname(".home") -- 获取房间服务 地址
    local r = {skynet.call(s,"lua","getchannel")} -- 请求房间id
    local channelid = r[1]

    local channel = mc.new{
        channel = channelid,
        dispatch = function (add, sess, msg, ...)
            skynet.error(playername ,"接收到消息-",msg)
        end
    }
    channel:subscribe()
    channel:publish(playername .. "进入了房间")
end)
-- 入口
-- 一个简单的记录比赛成绩的服务器

local skynet = require "skynet"
local snax = require "skynet.snax"
-- package.path = package.path .. ";./game/?.lua"
require "skynet.manager"

local self = {}
-- 每帧更新的函数列表
self.UpdateList = {}

-- snax服务启动入口
function init(...)
    skynet.error("GameMain 开始...")
    skynet.timeout(200, self.GameUpdate)
    skynet.timeout(50, function ()
        self.StartAllGlobalService()
    end)
end

-- 游戏主循环
function self.GameUpdate()
    skynet.timeout(50, self.GameUpdate)
    for k,v in pairs(self.UpdateList) do
        if type(v) == type(self.GameUpdate) then
            v()
        end
    end
end

-- 开启所有的初始服务
function self.StartAllGlobalService()
    local startservices = {
        "httpservice",

        "loginservice",
        "dipatchservice",
    }

    for k,v in pairs(startservices) do
        snax.globalservice(v)
    end

    local successCount = 0
    for k,v in pairs(startservices) do
        local ctl = snax.queryglobal(v)
        if ctl ~= nil then
            successCount = successCount+1
        end
    end
    skynet.error("服务器地址公网：115.29.240.135")
    skynet.error("服务器地址私网：172.16.214.62")
    skynet.error("GameMain 服务启动完成--",successCount,"/",#startservices)
end

return self
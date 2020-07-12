-- 组播
local this = {}
local  skynet = require "skynet"
local multicast = require "skynet.multicast"
local homechannel = nil  -- 房间的频道

require "skynet.manager"

skynet.start(function ()
    skynet.register(".home")  -- 给房间服务注册别名
    
    skynet.dispatch("lua", function(session, address, ask, args)
        if ask == "getchannel" then -- 返回对房间服务组播频道id的请求
            skynet.retpack(this.getchannel())
        end
    end)
    
    homechannel = multicast.new()  -- 创建频道实例
    
    skynet.timeout(10,function () -- 创建一个玩家
        skynet.newservice("test8_1", "疾风豪")
    end)
    skynet.timeout(20,function () -- 创建一个玩家
        skynet.newservice("test8_1", "泽拉斯")
    end)
    skynet.timeout(90,function () -- 创建一个玩家
        skynet.newservice("test8_1", "风之子")
    end)

    this.gamestart(3)
end)

function this.getchannel()
    return homechannel.channel
end

function this.gamestart(lt)
    if lt < 0 then
        return
    end
    skynet.timeout(100,function ()
        homechannel:publish("还有".. tostring(lt) .."S 开始游戏")
        this.gamestart(lt-1)
    end)
end
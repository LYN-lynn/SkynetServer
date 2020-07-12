local skynet = require "skynet"
local snax = require "skynet.snax"

local gamesnaxserctrl = nil

skynet.start(function ()
    gamesnaxserctrl = snax.newservice("test12_6")
    -- skynet.timeout(500, function ()
    --     gamesnaxserctrl.post.settips("准备版本更新")
    -- end)
    skynet.timeout(500, function ()
        skynet.error("游戏在运行？ = ", gamesnaxserctrl ~= nil)
        local hr = snax.hotfix(gamesnaxserctrl, [[
            local gametips
            local skynet
            function hotfix(...)
                gametips = "游戏准备热更，请保存你的数据"
            end
        ]])
        skynet.error("发热后=", hr)
    end)
end)
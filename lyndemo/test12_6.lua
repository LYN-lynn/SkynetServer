-- moni game -- test12_6
local skynet = require "skynet"
local snax = require "skynet.snax"

local gametips = ""

function init(...)
    skynet.error("game starting ...")
    gametips = "服务器已经启动了"
    skynet.timeout(50, gamemain)
end

function gamemain()
    skynet.timeout(50, gamemain)
    if #gametips <= 2 then
        return
    end
    skynet.error(gametips)
    gametips = SubUTF8String(gametips,#gametips-1)
end

function accept.settips(newtips)
    gametips = newtips
end

function SubUTF8String(s, n)
    local dropping = string.byte(s, n+1)
    if not dropping then return s end
    if dropping >= 128 and dropping < 192 then
        return SubUTF8String(s, n-1)
    end
    return string.sub(s, 1, n)
end
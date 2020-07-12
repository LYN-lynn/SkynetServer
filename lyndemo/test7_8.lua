-- test7_8.lua
local skynet = require "skynet"
require "skynet.manager"

skynet.start(function ()
    skynet.register(".call")

    skynet.timeout(100, task)
    skynet.timeout(0, task)
end)

function task ()
    local rspmsgs = {skynet.call(".ser", "lua", "你收到了吗2？", "巴拉巴拉小魔仙")}
    skynet.error("我问了对方收到了没，他回答说 ", rspmsgs[1], rspmsgs[2])
end
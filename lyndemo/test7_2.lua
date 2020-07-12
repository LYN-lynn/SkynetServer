-- test7_2.lua
local skynet = require "skynet"
require "skynet.manager"

skynet.start(function ()
    local r = skynet.send(".ser","lua" , "这是未打包消息。", "消息内容：一首交货")
    skynet.error("发送完毕1" , r)

    local packedmsg, sz = skynet.pack("打包消息", "消息内容，一手交钱")
    local r = skynet.rawsend(".ser","lua",packedmsg, sz)
    skynet.error("发送完毕2" , r)
end)
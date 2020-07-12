-- test12_1
local snax = require "skynet.snax"
local skynet =require "skynet"

skynet.start(function ()
    local sserctrl = snax.newservice("test12_2", 1,"12_2上线吧")
    skynet.error("snax service 已启动 - ", sserctrl)

    local r = sserctrl.post.letter("这是你的信件", "掌门爱你呦！")
    skynet.error("post.letter 的返回 ", r)

    local rs = sserctrl.req.chat("上线了吗？宝贝，我年龄", 25)
    skynet.error("我12_1收到消息", rs)

    sserctrl.post.quit("你可以下线了")
end)


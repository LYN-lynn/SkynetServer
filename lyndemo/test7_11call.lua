local skynet = require "skynet"



skynet.start(function ()
    task(10, "第1条消息", 500)
    task(20, "第2条消息", 80)
    task(30, "第3条消息", 200)
    task(40, "第4条消息", 50)
    task(50, "第5条消息", 10)
end)

-- ti：这个时间后才发送该请求
--- useti：处理这个任务需要的时间
function task(ti, con, useti)
    skynet.timeout(ti,function ()
        local rsp = skynet.call(".queuetest", "lua", useti, con)
    end)
    skynet.error("调用方：", con, "已发送")
end


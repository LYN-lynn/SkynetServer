-- test12_2

local snax = require "skynet.snax"
local skynet =require "skynet"

function init(...)
    local args = {...}
    skynet.error("12_2开始启动，参数：", ...)
end

function exit(...)
    skynet.error("12_2退出 参数", ...)
end

-- accept 的接收消息，无需返回
function accept.letter(...)
    skynet.error("12_2收到信件 ", ...)
    return "12_2尝试返回"
end

-- accept 的接收消息，无需返回
function accept.quit(...)
    skynet.error("12_2接到下线命令", ...)
    snax.exit() -- 这里需要显式调用
end

-- response 下的应答消息，需要返回
function response.chat(...)
    skynet.error("12_2收到消息：", ...)
    skynet.sleep(300)
    return "我收到了".."我年龄23"
end
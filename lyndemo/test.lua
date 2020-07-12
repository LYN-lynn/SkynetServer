-- 创建一个skynet服务
local skynet = require "skynet"

-- 调用skynet.start，并传入回调函数
skynet.start(function ()
    skynet.error("call back yes ✌---你好啊刘运宁")
end)
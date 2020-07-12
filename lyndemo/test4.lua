local  skynet = require "skynet"

local runTime = {}

table.insert(runTime, "a")

skynet.start(function ()
    skynet.error("test4 开始函数")
    if #runTime == 1 then
        skynet.error("第一次运行")
    else
        skynet.error("非第一次运行了啊")
    end
end)
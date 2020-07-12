local skynet = require "skynet"
local snax = require "skynet.snax"

local lnum = 10
gnum = 11

function accept.hot(arg1)
    skynet.error("原版 hot", lnum, gnum)
end

function fff()
    
end

function init(...)
    skynet.error("12_4 已经启动了")
end

function exit(...)
    skynet.error("12_4 退出")
end
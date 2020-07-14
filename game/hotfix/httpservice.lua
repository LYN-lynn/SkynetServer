local skynet = require "skynet"
local snax = require "skynet.snax"
local socket = require "skynet.socket"

local self = {}

self.services = {}

local accept = accept or {}

function init()
    local startCount = 1
    skynet.error("Http服务启动...")

    -- 启动多个热更处理的服务
    for i=1,startCount do
        table.insert( self.services, i, snax.newservice("hotfixservice", i))
    end

    local port = 9999
    local address = "172.16.214.62"
    local socketId = socket.listen(address, port)
    socket.start(socketId, self.AcceptFunc)
end

function self.AcceptFunc(sockeId, socketAddress)
    skynet.fork(function()
        self.services[1].post.enter(sockeId, socketAddress)
    end)
    socket.abandon(sockeId)
end


function accept.quit()
    for i=1,10 do
        self.services[i].post.quit()
    end
end
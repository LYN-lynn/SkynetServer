local skynet = require "skynet"
local socket = require("skynet.socket")

local self = {}

skynet.start(function (arg1, arg2, arg3)
    local address = "172.16.214.62"
    skynet.error("监听 ", address)
    local listensocketid = socket.open(address, 8888)
    skynet.fork(self.recv, listensocketid)
    skynet.fork(self.send, listensocketid)
end)

function self.recv(listensocketid)
    while true do
        local msg = socket.read(listensocketid)
        skynet.error("接收到 ", msg)
    end
end

function self.send(listensocketid)
    for i = 1, 10 do
        socket.write(listensocketid, "data "..i)
    end
end
local skynet = require "skynet"
local socket = require("skynet.socket")

local self = {}

skynet.start(function ()
    local address = "172.16.214.62"
    skynet.error("监听 ", address)
    local socketid = socket.listen(address, 8888)
    assert(socketid)
    socket.start(socketid, self.acceptfunc) -- 设置该id的socket在有连接时的回调（参数1：接入socketid，参数2：接入socket的地址IP）
end)

function self.acceptfunc(connsocketid, connectaddress)
    skynet.error("有新的连接 id=", connsocketid, " ip=", connectaddress)
    skynet.fork(function () -- 开启新的协程来处理这个连接
        socket.start(connsocketid)
        while true do
            -- local msg = socket.read(connsocketid)
            -- local msg = socket.readline(connsocketid)
            local msg = socket.readall(connsocketid) -- 对方断开后才会继续执行
            if msg then
                skynet.error("server 对方发送了", msg)
                socket.write(connsocketid, string.upper(msg))
            else
                socket.close(connsocketid)
                skynet.error("连接断开", connectaddress)
                return
            end
        end
    end)
end


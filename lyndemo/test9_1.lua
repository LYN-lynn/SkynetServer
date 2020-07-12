local skynet = require "skynet"
local socket = require("skynet.socket")


skynet.start(function ()
    local address = "172.16.214.62"
    skynet.error("监听 ", address)
    local socketid = socket.listen(address, 8888)
    assert(socketid)
    socket.start(socketid, Acceptfunc) -- 设置该id的socket在有连接时的回调（参数1：接入socketid，参数2：接入socket的地址IP）
    skynet.timeout(100, function ()
        skynet.newservice("test10_0")
    end)
end)

function Acceptfunc(connsocketid, connectaddress)
    skynet.error("server 有新的连接 id=", connsocketid, " IP=", connectaddress)
    skynet.fork(function (cid, cadd) -- 开启新的协程来处理这个连接
        socket.start(cid)
        while true do
            skynet.error("server 等待读取...")
            local msg,endstr = socket.readline(cid)
            if msg then
                if msg:sub(1,1) == "2" then
                    skynet.error("sleep")
                    skynet.sleep(300)
                end
                skynet.error("server 收到：", msg)
                socket.write(cid, string.upper(msg).. "--ser\n")
            else
                socket.close(cid)
                skynet.error("连接断开", cadd)
                return
            end
        end
    end, connsocketid, connectaddress)
end

local skynet = require "skynet"
require "skynet.manager"
local sc = require "skynet.socketchannel"

local this = {}
local channel = nil

-- 这是个特殊的函数，参数skt有两个方法，read和readlin
-- 该函数的返回值必须是两个
-- 第一个参数：为true时表示解析正常；
-- 为false时表示协议出错，这会导致连接断开且request的调用者也会获得一个error
-- 该函数内的任何error都会抛给request的调用者
function this.reponse(skt)
    return true, skt:read()
end

function this.task()
    local i = 0
    while i <= 3 do
        --第一参数是需要发送的请求，第二个参数是一个函数，用来接收响应的数据。
        --调用channel:request会自动连接指定的TCP服务，并且发送请求消息。
        --该函数阻塞，返回读到的内容。
        local resp = channel:request(i.."channel request - ".."\n", this.reponse)
        skynet.error("client 收到", resp) -- 上一个请求的回应没有收到时，无法发送下一个请求
        i = i + 1
    end
    skynet.exit()
end

skynet.start(function ()
    skynet.timeout(100, function ()
        channel = sc.channel{
            host = "172.16.214.62",
            port = "8888",
        } -- socketchannel对象
        skynet.error(channel.__host)
        skynet.fork(this.task)
    end)
end)
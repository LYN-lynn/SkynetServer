local skynet = require "skynet"
require "skynet.manager"
local sc = require "skynet.socketchannel"

local self = {}

local channel = sc.channel{
    host = "115.29.240.135",
    port = "8888",
    response = self.dispatch
}

function self.dispatch(skt)
    skynet.error("dispatch")
    local rmsg,rend = skt:readline()
    local session = tonumber(string.sub(rmsg, 1, 1)) -- 从第一个字符开始，长度为1
    skynet.error("debug session =", session)
    return session, true, rmsg -- 模式2需返回三个参数，新增第一个参数是个session
end



function self.sendtask()
    local i = 0
    while i <= 3 do
        skynet.fork(function (session) -- 开启协程发送，携带session
            skynet.error("client send")
            local resp = channel:request(session.."channel request".."\n", session)
            skynet.error("cleint收到回应", resp, session)
        end, i)
        i = i + 1
    end
end

skynet.start(function ()
    skynet.timeout(40, function ()
        skynet.error(channel.__host)
        skynet.fork(self.sendtask)
    end)
end)
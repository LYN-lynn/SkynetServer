-- package.path = "luaclib/?.lua"
local crypt = require "client.crypt"
local skynet = require "skynet"
local login = require "snax.loginserver"

local server = {
    host = "172.16.214.62",
    port = 8888,
    multilogin = false,
    name = "login_server"
}

-- 你需要实现这个方法，对一个客户端发送过来的token做验证。
-- 如果验证不通过，则通过error抛出异常。
-- 如果验证通过，则返回用户希望进入的登陆点以及用户名
-- 登陆点可以是包含在 token 内由用户自行决定,也可以在这里实现一个负载均衡器来选择）？？？
function server.auth_handler(token)
    local user, server, pwd = token:match("([^@]+)@([^:]+):(.+)")
    user = crypt.base64decode(user)
    server = crypt.base64decode(server)
    pwd = crypt.base64decode(pwd)

    skynet.error(string.format( "user=%s;pwd=%s;token=%S",user,pwd,server ))

    assert(pwd=="yangyang","密码错误")

    return server, user
end

local subid = 0

function server.login_handler(server, uid, secret)
    skynet.error(string.format("登录玩家uid=%s@%s;密匙is:%s", uid,server,secret))
    subid = subid + 1
    return subid
end

local CMD = {}

function CMD.register_gate(server, address)
    skynet.error("cmd regisetr gate")
end

-- 必须实现，用以处理lua消息
function server.command_handler(command, ...)
    local f = assert(CMD[command])
    return(f(...))
end

login(server) -- 服务启动需要参数
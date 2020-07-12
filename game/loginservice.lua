local snax = require "skynet.snax"
local skynet = require "skynet"
-- local socket = require "socket"
local sockethelper = require "helper.sockethelper"
local pbhelper = require "helper.protobufhelper"
require "skynet.manager"

local this = {}

local accept = accept or {}

function init(sername, ...)
    skynet.error(snax.self().type)
    snax.bind(snax.self(), "loginservice")
end

function accept.enter(connetctid, connectaddress, loginstrmsg)
    -- 从PB消息载体获取正式消息，然后开启协程去处理这个登录
    -- loginpbmsg 就是登录消息，str，需要解析
    skynet.fork(this.dologin, connetctid, connectaddress, loginstrmsg)
end

function this.dologin(connectid, connectaddress, loginstrmsg, testmsg)
    local loginpbmsg = pbhelper.Deserlize(pbhelper.ProtoInfos.LOGINREGIST, loginstrmsg)
    local rmsg = nil
    if loginpbmsg.Name == "lyn" and loginpbmsg.PassWord == "123" then
        rmsg = "OK"
    else
        rmsg = "NO"
    end
    skynet.error("登录结果",rmsg)
    -- 正式消息表
    local loginbacktable = {}
    loginbacktable.MsgType = "LOGIN"
    loginbacktable.Name = rmsg
    loginbacktable.PassWord = "true"

    -- 序列化外壳消息
    local pbmsgtosend = pbhelper.createstrmsg(pbhelper.ProtoInfos.LOGINREGIST, loginbacktable)
    -- 打包，并发送
    sockethelper.packsend(pbmsgtosend, connectid)
    -- 不关闭
    -- socket.close(connectid)
end
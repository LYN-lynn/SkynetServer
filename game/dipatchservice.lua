-- 该服务用于
-- 监听端口
-- 获取消息-解析头部-获取整体消息-解析外层消息-依据外层消息类型，分发消息到各个服务
local self = {}

local skynet = require "skynet"
local socket = require "skynet.socket"
local snax = require "skynet.snax"
local pbhelper = require "helper.protobufhelper"
local blacklist = require "blacklist"

function init ()
    -- 获取登录服务
    local address = "172.16.214.62"
    local port = 60006
    skynet.error("监听 ", address, "端口", port)
    local socketid = socket.listen(address, port)
    assert(socketid)
    socket.start(socketid, self.Acceptfunc) -- 设置该id的socket在有连接时的回调（参数1：接入socketid，参数2：接入socket的地址IP）
end

function self.Acceptfunc(connsocketid, connectaddress)
    skynet.error(connectaddress, "------------------------------");
    local connectip = string.sub( connectaddress, 1, string.find( connectaddress,":")-1)
    if not blacklist.canConnect(connectaddress) then
        return;
    end
    skynet.fork(self.dispatchmsg, connsocketid, connectaddress)
end

-- 接收数据并解析出载体消息中保存到额正式信息的类型，然后将消息（str）发送给服务
-- socket消息（头部+本体）；pb信息（载体消息(正式消息))---
function self.dispatchmsg(connectsocketid, connectaddress)
    skynet.error("server 有新的连接 id=", connectsocketid, " IP=", connectaddress)

    socket.start(connectsocketid)
    while true do
        local readsize = 20
        -- 阻塞读取长度信息 前20字节头部信息
        skynet.error("server 等待读取长度信息...")
        local check, _m = socket.read(connectsocketid, readsize)
        if check == false then
            break
        end

        -- 获取前头部信息代表正式内容长度的数字
        local tail = 1
        while string.byte( check, tail, tail ) ~= 0 do
            tail = tail + 1
        end
        readsize = tonumber(string.sub( check, 1, tail-1))
        skynet.error("读取头部消息完毕，头部长", #check ,"其指示该消息本体长度为", readsize)

        -- 阻塞读取正式内容，长度就是头部所标识的长度
        skynet.error("server 阻塞读取socket消息本体内容...")
        local content, _m = socket.read(connectsocketid, readsize)
        skynet.error("server 阻塞读取socket消息本体内容完毕=", content)
        if content == false then
            skynet.error("socket消息本体读取错误", #_m)
            break
        end

        -- 核心消息是一个protobuff信息，开始解析（载体消息都是这个文件解析MessageProto.Message）
        local msg,dmsg = pbhelper.Deserlize(pbhelper.ProtoInfos.MESSAGE, content)
        if msg == false then
            skynet.error("protobuff 载体消息解析失败", dmsg)
            return
        else
            skynet.error("protobuff 载体消息解析成功")

            -- 依据载体消息Type，分发str消息到服务
            local dipatchtoservicename = pbhelper.ProtoInfos[msg.MsgType].servicename
            skynet.error("正式消息type=", msg.MsgType, "分发到服务", dipatchtoservicename)
            local servicectrl = snax.queryglobal(dipatchtoservicename)
            servicectrl.post.enter(connectsocketid, connectaddress, msg.Msg)
        end
    end
    socket.abandon(connectsocketid)
end

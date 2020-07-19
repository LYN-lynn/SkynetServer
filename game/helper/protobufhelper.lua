-- 由于消息解析需要指定包体名称，如果直接发送各种消息，则难以告知解析方式
-- 所以将所有消息都放在一个同一的消息内部，同一的消息则使用固定的解析方式
-- 根据统一消息类型判断正式消息怎么使用(如果不是bytes方式保存正式消息,而是直接保存正式消息的类型字段,则正式消息无需解析)

local skynet = require "skynet"

local protobuf = require "protobuf"

protobuf.register_file("./protos/GameMsg.pb")

local self = {}
-- 协议的信息 依据正式消息的MsgType查找PB解包和打包的package，以及该package使用的服务名
-- 为该表键载体消息的MsgType字段
-- 解析和打包pb协议使用package的值
-- 分发消息到服务其名为servicename的值
-- 正式消息赋值给载体消息时，使用itemname的值作为字段名
self.ProtoInfos={
    MESSAGE = {
        package = "MessageProto.Message"
    },
    LOGINREGIST={
        msgtype = "LOGINREGIST",
        package="MessageProto.LoginRegistMsg",
        servicename="loginservice",
    },
    HOTFIX={
        msgtype = "HOTFIX",
        package="MessageProto.HotfixMsg",
        servicename="hotfixservice",
    },
}

-- 自助打包消息
-- 对一个正式消息打包
-- 1.创建载体消息
-- 2.构建正式消息
function self.packcarrier(packageinfo, mainmsgstr)
    if packageinfo == nil then
        return nil
    end
    local carriermsg = {}
    carriermsg.MsgType = packageinfo.msgtype
    carriermsg.Msg = mainmsgstr
    return carriermsg -- 返回打包使用的package参数+整个载体消息
end

function self.Serlize(packageinfo, content)
    skynet.error("序列化包名", packageinfo.package)
    local r = protobuf.encode(packageinfo.package, content)
    skynet.error("序列化成功", packageinfo.package)
    return r
end

function self.Deserlize(packageinfo, content)
    assert(packageinfo) 
    assert(content)
    skynet.error("反序列化包名 ", packageinfo.package)
    local r = protobuf.decode(packageinfo.package, content)
    skynet.error("反序列化成功")
    return r
end

-- 创建str消息-包括了序列化主要消息，创建载体消息并赋值主要消息，序列化载体消息
-- prototype pbhelper.Protoinfos
-- mainpbmsg {name="lyn", id=1}
function self.createstrmsg(prototype ,mainpbmsg)
        -- 正式消息序列化后的string
        local serlizedmainmsgstr = self.Serlize(prototype, mainpbmsg)
        -- 打包正式消息到外壳消息
        local carrierpbmsg =  self.packcarrier(prototype, serlizedmainmsgstr)
        -- 序列化载体消息
        return self.Serlize(self.ProtoInfos.MESSAGE, carrierpbmsg)
end

return self
local skynet = require "skynet"
local snaz = require "skynet.snax"
local pbhelper = require "helper.protobufhelper"
local md5 = require "md5"

function init(...)
    -- 测试md5
    for k,v in pairs(md5) do
        print(k,v)
    end

    local r = md5.sum("hello");
    print(string.byte( r,1,#r ))
    print(r)


    -- 测试了pb序列化问题 -- 流程错误，参数错误，shitlua
    -- skynet.error("test 启动")

    -- local loginbacktable = {}
    -- loginbacktable.MsgType = "LOGIN"
    -- loginbacktable.Name = "success"
    -- loginbacktable.PassWord = "true"
    -- skynet.error("序列化正式")
    -- local loginbackpbmsg = pbhelper.Serlize(pbhelper.ProtoInfos.LOGINREGIST, loginbacktable)
    -- skynet.error("序列化 OK-----------")


    -- local carriortable = {}
    -- carriortable.MsgType = "LOGINREGIST"
    -- carriortable.Msg = loginbackpbmsg
    -- skynet.error("序列化头部")
    -- local carriorpbmsg = pbhelper.Serlize(pbhelper.ProtoInfos.MESSAGE, carriortable)
    -- skynet.error("序列化头部 OK-----------")

    -- -- local packagename, packedmsg =  pbhelper.packcarrier(pbhelper.ProtoInfos.LOGINREGIST, loginbackpbmsg)
    -- -- skynet.error("发送的消息", packagename, packedmsg)

    -- -- for k,v in pairs(packedmsg) do
    -- --     skynet.error(k,v)
    -- -- end

    -- -- -- 打包头部成为载体pb协议后，无法序列化
    -- -- -- 测试：直接序列化反序列化的发送接收到的载体信息，然后发送
    -- -- -- local pbmsgtosend = pbhelper.Serlize(packagename, packedmsg)
    -- -- local pbmsgtosend = pbhelper.Serlize(packagename, packedmsg)
end
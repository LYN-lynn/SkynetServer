local snax = require "skynet.snax"
local skynet = require "skynet"
local socketsendhelper = require "helper.socketsendhelper"
local pbhelper = require "helper.protobufhelper"
require "skynet.manager"

local registedPlayer={}

local accept = accept or {}

function init(sername, ...)
    skynet.error(snax.self().type)
    snax.bind(snax.self(), "loginservice")
end

-- [[设置登录或注册的返回结果]]------------------------------------
-- 返回一个序列化后的PB字符串
local function getResponse(msgType, state, rspMsg)
    -- 正式消息表
    local loginbacktable = {}
    loginbacktable.MsgType = msgType
    loginbacktable.Name = state
    loginbacktable.PassWord = rspMsg
    -- 序列化外壳消息
    return pbhelper.createstrmsg(pbhelper.ProtoInfos.LOGINREGIST, loginbacktable)
end


-- 登录和注册类型的区分标签
local MSGTYPE = {
    LOGIN="LOGIN", REGISETR="REGISETR"
}

-- [[注册相关]]----------------------
-- 注册错误的类型
local ENUM_RegistResult = {
    ERR_NAMEREGISTED = "名称已被注册",
    ERR_NAMETOOSHORT = "名称长度太短",
    ERR_NAMETOOLONG = "名称长度太长",
    ERR_PWDTOOSHORT = "密码太短",
    ERR_PWDTOOLONG = "密码长",
    SUCCED = "注册完成"
}
-- 注册条件
local registCondition = {
    NAMELEN = {MIN = 5, MAX = 15},
    PWDLEN = {MIN = 5, MAX = 15},
}
-- 尝试注册
local function tryRegist(newPlayerName, newPlayerPwd)
    -- 检查名称长度
    skynet.error("开始处理注册")
    local rpsMsg = "not set value1"
    if #newPlayerName < registCondition.NAMELEN.MIN then
        rpsMsg = ENUM_RegistResult.ERR_NAMETOOSHORT
    end
    if #newPlayerName > registCondition.NAMELEN.MAX then
        rpsMsg = ENUM_RegistResult.ERR_NAMETOOLONG
    end

    -- 检查密码长度
    if #newPlayerPwd < registCondition.PWDLEN.MIN then
        rpsMsg = ENUM_RegistResult.ERR_PWDTOOSHORT
    end
    if #newPlayerPwd > registCondition.PWDLEN.MAX then
        rpsMsg = ENUM_RegistResult.ERR_PWDTOOLONG
    end

    -- 检查是否已被注册
    if registedPlayer[newPlayerName] ~= nil then
        rpsMsg = ENUM_RegistResult.ERR_NAMEREGISTED
    else
        rpsMsg = ENUM_RegistResult.SUCCED
        registedPlayer[newPlayerName] = newPlayerPwd
    end

    local state = "NO"
    if rpsMsg==ENUM_RegistResult.SUCCED then
        state = "OK"
    end

    -- 注册
    skynet.error("注册处理", newPlayerName, newPlayerPwd, "处理结果", state, rpsMsg)
    return getResponse(MSGTYPE.REGIST, state, rpsMsg)
end


-- [[登录相关]]-------------------------------
local ENUM_LoginResult = {
    ERR_ERROR = "用户名或密码错误",
    SUCCED = "登录成功"
}
-- 尝试登录
local function tryLogin(loginName, loginPwd)
    skynet.error("开始处理登录")
    local rspMsg = "not set value"
    local state = "not set value"
    if registedPlayer[loginName] == loginPwd then
        state = "OK"
        rspMsg = ENUM_LoginResult.SUCCED
    else
        state = "NO"
        rspMsg = ENUM_LoginResult.ERR_ERROR
    end
    skynet.error("登录处理", loginName, loginPwd, "处理结果", state)
    return getResponse(MSGTYPE.LOGIN, state, rspMsg)
end


-- [[处理登录和注册的协程入口]]-------------------
local function doLogin (connectId, connectaddress, loginStrMsg)
    local loginPbMsg = pbhelper.Deserlize(pbhelper.ProtoInfos.LOGINREGIST, loginStrMsg)
    local tryResult = "not set value"
    if loginPbMsg.MsgType == MSGTYPE.LOGIN then
        tryResult = tryLogin(loginPbMsg.Name, loginPbMsg.PassWord)
    elseif loginPbMsg.MsgType == MSGTYPE.REGISETR then
        tryResult = tryRegist(loginPbMsg.Name, loginPbMsg.PassWord)
    else
        skynet.error("无法识别的登录/注册消息 --", loginPbMsg.MsgType)
    end
    -- 打包，并发送
    socketsendhelper.packsend(tryResult, connectId)
end

-- [[[[[[[[[该服务入口]]]]]]]]]
function accept.enter(connetctid, connectaddress, msg)
    -- 从PB消息载体获取正式消息，然后开启协程去处理这个登录
    -- loginpbmsg 就是登录消息，str，需要解析
    assert(connetctid) assert(connectaddress)
    skynet.fork(doLogin, connetctid, connectaddress, msg)
end
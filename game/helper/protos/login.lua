-- // 登录消息类型
-- enum LoginRegistMsgType {
--   LOGIN = 0;
--   REGISETR = 1;
-- }
-- // 登陆消息主体
-- message LoginRegistMsg{
--   LoginRegistMsgType MsgType = 1;
--   // 客户端：登录或注册昵称
--   // 服务端：登录或注册返回信息OK/NO
--   string Name = 2; 
--   // 客户端：登录或注册密码
--   // 服务端：登录或注册返回信息
--   string PassWord = 3;
-- }

local self = {}

-- 登录和注册类型的区分标签
self.ENUM_MSGTYPE = {
    LOGIN="LOGIN", REGISETR="REGISETR"
}

-- [[注册相关]]----------------------
-- 注册错误的类型
self.ENUM_RegistResult = {
    ERR_NAMEREGISTED = "名称已被注册",
    ERR_NAMETOOSHORT = "名称长度太短",
    ERR_NAMETOOLONG = "名称长度太长",
    ERR_PWDTOOSHORT = "密码太短",
    ERR_PWDTOOLONG = "密码长",
    SUCCED = "注册完成"
}

-- 注册条件
self.ENUM_RegistCondition = {
    NAMELEN = {MIN = 5, MAX = 15},
    PWDLEN = {MIN = 5, MAX = 15},
}

-- [[登录相关]]-------------------------------
self.ENUM_LoginResult = {
    ERR_ERROR = "用户名或密码错误",
    SUCCED = "登录成功"
}

return self
local self = {}

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

return self
local skynet = require "skynet"
local snax = require "skynet.snax"
local pbhelper = require "helper.protobufhelper"
local MD5 = require "md5.core"

local this = {}
local accept = accept or {}

-- 游戏启动时检查更新
local ProjectRootPath = ""
local MD5FilePath = ProjectRootPath .. "/"

function  init(...)
    skynet.error("热更服务已启动")
end

function accept.enter(socketid, connectaddress)
    skynet.fork(this.hotfix, socketid, connectaddress)
end

function this.hotfix(socketid, connectaddress)

end

-- 发送文件内容
function this.sendfile(socketid, filepath)
    local fd = assert(io.open(filepath, "r"))
    local conetnt = fd:read("*all")
end
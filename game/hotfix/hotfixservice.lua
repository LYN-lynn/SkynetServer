local skynet = require "skynet"
local snax = require "skynet.snax"
local socket = require "skynet.socket"
local httpd = require "http.httpd"
local urlLib = require "http.url"
local skynetSocketHelper = require "http.sockethelper"

local this = {}
local accept = accept or {}
local response = response or {}

-- 游戏启动时检查更新
local StreamingAssetsPath = ""

function  init(...)
    skynet.error("热更服务已启动", ...)
end

function accept.enter(socketid, connectaddress)
    skynet.fork(this.hotfix, socketid, connectaddress)
end

-- 退出请求
function accept.quit()
    
end

-- 查询当前连接数
function response.connectCount()
    
end

-- 开始处理这个连接的热更请求
-- 测试：直接发送一个文件
function this.hotfix(socketid, connectaddress)
    local readFunc =  skynetSocketHelper.readfunc(socketid)
    local req = {httpd.read_request(readFunc, 8192)}
    skynet.error("输出http请求解析结果")
    for k,v in pairs(req) do
        skynet.error(k,v)
    end
end

-- 发送文件内容
function this.sendfile(socketid, filepath)
    local fd = assert(io.open(filepath, "r"))
    local conetnt = fd:read("*all")
end
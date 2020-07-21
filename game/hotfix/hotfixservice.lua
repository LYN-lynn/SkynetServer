local skynet = require "skynet"
local snax = require "skynet.snax"
local socket = require "skynet.socket"
local httpd = require "http.httpd"
local urlLib = require "http.url"
local skynetSocketHelper = require "http.sockethelper"

local self = {}
self.assetsRootPath = "/home/skynet/game/Assets"

local accept = accept or {}
local response = response or {}

-- 游戏启动时检查更新
local StreamingAssetsPath = ""

function  init(...)
    skynet.error("热更服务已启动", ...)
end

function accept.enter(socketId, socketAddress)
    skynet.fork(self.hotfix, socketId, socketAddress)
end

-- 退出请求
function accept.quit()
    
end

-- 查询当前连接数
function response.connectCount()
    
end

-- 开始处理这个连接的热更请求
-- 测试：直接发送一个文件
function self.hotfix(socketId, socketAddress)
    socket.start(socketId)

    skynet.error("----处理socketID-----", socketId)
    local ok, contentStr = self.doHttpRequest(socketId, socketAddress)
    if ok then
        local rspState = "200"
        contentStr = contentStr .. "\r\n\r\n" -- 用以标记http响应结束
        local rspOk, rspErr = httpd.write_response(skynetSocketHelper.writefunc(socketId), rspState, contentStr)
        skynet.error("响应", rspState, "响应内容长度", #contentStr)
        skynet.error("响应函数返回", rspOk, rspErr)
    else
        local rspState = "400"
        httpd.write_response(skynetSocketHelper.writefunc(socketId), rspState, "404")
    end
    socket.disconnected(socketId)
    socket.close(socketId)
end

-- 处理http请求，返回请求的文件
function self.doHttpRequest(socketId, socketAddress)
    local code, url, method, header, body = httpd.read_request(skynetSocketHelper.readfunc(socketId), 8192)
    skynet.error("输出http请求解析结果")
    skynet.error("code=", code)
    skynet.error("url", url)
    skynet.error("header", header)
    skynet.error("bdoy",body)

    skynet.error("解析结果：", code)
    if code ~= 200 then
        skynet.error("解析失败，来自",socketId, socketAddress, code)
        socket.close(socketId)
        return false
    end
    skynet.error("解析成功，来自", socketAddress)

    local path, query = urlLib.parse(url)
    skynet.error("解析url")
    skynet.error(path,query)
    local targetAssetPath = self.assetsRootPath .. path
    skynet.error("请求资源路径为", targetAssetPath)
    if #path <= 1 then
        skynet.error("路径太短")
        return  false;
    end
    if string.find( path,"..", 1, true) ~= nil then -- true 关闭匹配模式
        skynet.error("不能包含..的路径", path)
        return false
    end
    local fd = io.open(targetAssetPath, "r")
    if fd == nil then
        skynet.error("请求资源", targetAssetPath, "不存在")
        return false
    end
    local assetContent = fd:read("*a")
    return true, assetContent
end

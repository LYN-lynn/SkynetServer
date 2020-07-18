local skynet = require "skynet"
local snax = require "skynet.snax"
local socket = require "skynet.socket"
local skynetSocketHelper = require "http.sockethelper"
local httpd = require "http.httpd"
local urlLib = require "http.url"


local self = {}

self.services = {}

local accept = accept or {}

function init()
    local startCount = 1
    self.services = snax.newservice("hotfixservice")
    
    local port = 80
    local address = "172.16.214.62"
    local socketId = socket.listen(address, port)
    socket.start(socketId, self.AcceptFunc)
    
    skynet.error("Http服务启动，端口", port, "地址", address)
end

function self.AcceptFunc(socketId, socketAddress)
    self.services.post.enter(socketId, socketAddress)
end


function accept.quit()
    for i=1,10 do
        self.services[i].post.quit()
    end
end
local skynet = require "skynet"
local httpc = require "http.httpc"
local dns = require "skynet.dns"

local function main()
    httpc.dns() -- set dns server
    httpc.timeout = 100 -- set timeout 1 second
    print("GET 115.29.240.135")
    local respheader = {"haah"}
    local status, body = httpc.request("GET", "115.29.240.135", "/login", respheader, { host = "115.29.240.135" })
    --local status, body = httpc.get("baidu.com", "/", respheader, { host = "baidu.com" })
    print("[header] =====>")
    for k,v in pairs(respheader) do
        print(k,v)
    end
    print("[body] =====>", status)
    print(body)
end

skynet.start(function()
    print(pcall(main))
    skynet.exit()
end)

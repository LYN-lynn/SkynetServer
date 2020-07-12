-- 测试全局别名不允许二次修改

local  skynet = require "skynet"
-- local  skynetmanager = require "skynet.manager"
require "skynet.manager"

local  skynethabor = require "skynet.harbor"

skynet.start(function ()
    local  handler = skynet.newservice("test5call")
    skynet.error("准备命名1", type(skynethabor))
    for k,v in pairs(skynethabor) do
        skynet.error(k,v)
    end
    skynet.error("=== ==== ===")

    skynet.name("globalname2", handler)
    skynet.error("准备命名2")
    skynet.name("globalname2", handler)
    skynet.queryservice(true,"globalname2")
end)
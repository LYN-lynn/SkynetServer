local snax = require "snax"

local name = "main.lua"
local r = nil

-- 启动一个服务（可以多份），name为服务名，返回一控制对象，用于和服务交互
-- 多次调用会启动多个实例
-- 多个实例彼此独立，由控制对象区分
-- 返回值是对象，不是服务地址
r = snax.newservice(name, ...)

-- 和上面一样，一个节点上只会启动一份。多次调用只会返回相同的对象
r = snax.uniqueservice(name, ...)

-- 一样，全局唯一服务
r = snax.globalservice(name, ...)

-- 查询服务
-- 查询一个当前节点的具体服务，返回控制对象。如未启动，则阻塞等待
r = snax.queryservice(name)

-- 同上，查询全局节点的
r = snax.queryglobal(name)

-- 获取自己的服务的控制对象
r = snax.self()

-- snax服务退出
-- 让一个snax服务退出
snax.kill(r)

-- 退出当前 相当于snax.kill(snax.self(),...)
snax.exit()


-- 服务调度相关的API

local  skynet = require("skynet")

-- 让当前人物等待一段时间，时长为：0.01*num 秒
skynet.sleep(num)

-- 启动一个新的人物执行函数func，执行结束后返回其handle
-- 如果自己开启协程取执行，会打乱skynet的工作流程
skynet.fork(func, ...)

-- 让出当前的任务，随后继续执行（使得本服务内其他任务有机会执行）
skynet.yield()

-- 让出当前任务，不再执行，直到用wakeup唤醒
skynet.wait(token)

-- 唤醒一个wait/sleep，处于等待状态的任务
skynet.wakeup(token)

-- 设定一个定时触发函数func，事件为ti*0.01 秒
skynet.timeout(ti,func)

-- 返回当前进程启动时的时间（UTC）
skynet.starttime()

-- 返回当前进程启动后经过的时间（0.01）
skynet.now()

-- 返回通过starttime和now计算出当前utc
skynet.time()


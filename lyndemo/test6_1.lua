
local  skynet = require "skynet"


-- -- 测试sleep
-- local  time_s = 1
-- skynet.start(function ()
--     skynet.error("sleep start")
--     -- skynet.sleep(ti * 100,token)
--     skynet.sleep(time_s * 100)
--     skynet.error("sleep over")
-- end)

-- -- 测试开启新线程
-- -- ?开启后会阻塞当前任务吗：不会
-- skynet.start(function ()
--     skynet.error("main 开始fork了")
--     -- skynet.fork(task(),...)
--     skynet.fork(task)
--     skynet.error("main 结束fork了")
-- end)

-- function task()
--     local ti = 5
--     skynet.error("我是task 我要睡觉秒=", ti)
--     skynet.sleep(ti * 100)
--     skynet.error("我是task 我要睡觉结束了")
-- end

-- -- 测试，让长时间执行的任务让出
-- -- 注意：sleep状态下的任务，没有占用资源

-- skynet.start(function ()
--     skynet.fork(task, "T1")
--     skynet.fork(task, "T2")
--     skynet.error("主任务fork结束")
-- end)

-- function task(name)
--     skynet.error(name, "开始")
--     work(name)
--     skynet.error(name, "结束")
-- end

-- function work(n)
--     t=1000000000
--     for i = 1, t-1 do
--         if i >= 100000000 and i%100000000 == 0 then
--             skynet.error(n, "让出：", i)
--             skynet.yield()
--         end
--     end
-- end 

-- -- 测试延时执行函数
-- -- 延时执行函数怎么传递参数？lualib里延时函数没有三参数的重载，下面使用了闭包的方式。
-- skynet.start(function ()
--     args = "这是参数"
--     skynet.timeout(500,function ()
--         skynet.error(args)
--     end)
-- end)

-- -- 获取时间

-- skynet.start(function ()
--     local  _startTime = skynet.starttime()
--     local  _time = skynet.time()
--     local  _now = skynet.now()

--     skynet.error("starttime", _startTime)
--     skynet.error("time ===", _time)
--     skynet.error("now ====", _now)

--     skynet.sleep(2 * 100) --S

--     skynet.error("starttime", skynet.starttime() - _startTime)
--     skynet.error("time ===", skynet.time() - _time)
--     skynet.error("now ====", skynet.now() - _now)

-- end)

-- -- 简单的任务同步方案。

-- local cur = 0

-- skynet.start(function ()
--     skynet.timeout(100, 
--     function ()
--         skynet.error("开始fork所有任务")
--         skynet.fork(task,5)
--         skynet.fork(task,4)
--         skynet.fork(task,2)
--         skynet.fork(task,1)
--         skynet.fork(task,3)
--         skynet.error("fork完成")
--     end)
--     skynet.error("start over")
-- end)

-- function task(m)
--     while cur ~= m-1 do
--         skynet.yield()
--     end
--     skynet.error("当前：", m)
--     cur = m
-- end


-- 异常处理

skynet.start(function ()
    skynet.fork(pcall,task1, "has err func")
    skynet.fork(pcall,task2, "right fucn")
    skynet.error("fork 完成")
end)

function task1(arg)
    skynet.error(arg, "-开始")
    skynet.sleep(1 * 100) --S
    assert(err)
    skynet.error(arg, "-结束")
end

function task2(arg)
    skynet.error(arg, "-开始")
    skynet.sleep(2 * 100) --S
    skynet.error(arg, "-结束")
end
local skynet = require("skynet")

-- 获取config注册环境变量
skynet.getenv(varName)

-- 设置一些环境变量，注意不要设置已经存在的环境变量
skynet.setenv(key,value)

-- 打印函数
skynet.error(exceptionMsg)

-- 同func函数初始化服务，并将消息处理函数注册到C层，让该服务可以工作。
skynet.start(start_func)

-- 服务尚未初始化时：将这个函数注册为初始化函数。
-- 服务已经初始化时：立即执行这个函数。
skynet.init(func)

-- 结束当前服务
skynet.exit()

-- 获取当前服务的handle
skynet.self()

-- adde 就是skynet.self() ，这个函数将其转换成字符串
skynet.address(addr)

-- 退出skynet进程
-- 需要：require("skynet.manager")
skynet.abort()

-- address = skynet.address() 
-- 杀掉这个服务
-- 可以强制结束其他服务，但这样不安全，更安全的做法是：
-- 以通知的形式告知需要结束的服务，让其自己处理，然后自行调用skynet.exit()。
-- 否则该服务处理完一条消息后会毫无征兆地退出。
-- skynet.kill(skynet.self()) 和 skynet.exit()相比，后者更安全。
skynet.kill(address)


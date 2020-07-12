-- test12_3

local skynet = require "skynet"
local snax = require "skynet.snax"

skynet.start(function ()
    local snaxserctrl = snax.newservice("test12_4")
    skynet.error("第一次调用", snaxserctrl)
    snaxserctrl.post.hot()

    -- 不映射局部变量时，skynet和lnum都访问不到
    -- snax.hotfix(snaxserctrl, [[
    --     function accept.hot(arg1)
    --         print("变态盗版", lnum, gnum)
    --     end
    -- ]])

    -- 映射呢之后就可以访问到了
    snax.hotfix(snaxserctrl, [[
        local skynet
        local lnum
        function accept.hot(arg1)
            skynet.error("变态盗版", lnum, gnum)
        end
    ]])

    skynet.error("第2次调用")
    snaxserctrl.post.hot()
end)
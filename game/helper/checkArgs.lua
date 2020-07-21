local self = {}

self.TYPE = {
    BOOL = "boolean", NUM = "number", TABLE = "table", USERDATA = "userdata", NIL = "nil"
}

function self.checkNil(...)
    for k,v in pairs({...}) do
        assert(v~=nil, "参数检查未通过")
    end
end

-- ... = {string, arg, num , arg2}
function self.checkType(...)
    local checkTypeArgTable = {...}
    if #checkTypeArgTable % 2 == 1 then
        assert(false, "断言参数类型检查必须为偶数个参数")
    end

    for i = 1, #checkTypeArgTable, 2 do
        assert(type(checkTypeArgTable[i]==checkTypeArgTable[i+1]), "断言类型失败")
    end
end
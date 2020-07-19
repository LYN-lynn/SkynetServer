local self = {}

self.blacklist = {
    {"183.136.225.43", 0},
    {"80.82.70.187", 0},
    {"101.133.149.35", 0},
    {"223.71.167.164", 0},
    {"172.105.238.87",0},
    {"143.92.32.106",0},
    {"195.144.21.56",0},
    {"77.247.108.119",0},
    {"42.240.133.87",0},
    {"139.162.81.62",0},
    {"35.188.133.59",0},
    {"42.92.63.9",0},
    {"198.143.133.154",0},
    {"",0},
    {"",0},
    {"",0},
    {"",0},
    {"",0},
    {"",0},
    {"",0},
    {"",0},
}

function self.canConnect(connectAddress)
    local ip = string.sub( connectAddress, 1, string.find( connectAddress,":"))
    for blackIP,refuseCoun in pairs(self.blacklist) do
        if blackIP == ip then
            refuseCoun = refuseCoun+1
            self.ShowRefuseList()
            return false
        end
    end
    return true
end

function self.ShowRefuseList()
    for k,v in pairs(self.blacklist) do
        print("IP=", k ,"次数=", v)
    end
end

return self

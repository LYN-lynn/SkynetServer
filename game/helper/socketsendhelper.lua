local socket = require "skynet.socket"

local this = {}

function this.packmsg(msg)
    local msglen = tostring(#msg)
    while #msglen<20 do
        msglen = msglen.." "
    end
    return msglen..msg
end

function this.unpakcmsg(msg)
    return string.sub( msg, 21)
end

function this.packsend(msg, socketid)
    msg = this.packmsg(msg)
    socket.write(socketid, msg)
end

return this
local  skynet = require "skynet"

require "skynet.manager"

local  msg,sz = skynet.pack("新的消息" , {"第一", "第二"}, 2)

local title, msgs, count = skynet.unpack(msg, sz)

skynet.error(title, msgs, count)

skynet.trash(msg,sz)
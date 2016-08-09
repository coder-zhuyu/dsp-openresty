local redis = require "resty.iredis"

local red = redis:new({["ip"]="10.0.61.51", ["port"]=6379})

local _M = {}

function _M.get_from_redis(key)
    local res, err = red:get(key)
    if res then
        return res
    else
        return nil
    end
end

function _M.mget_from_redis(args)
    local res, err = red:mget(unpack(args))
    if res then
        return res
    else
        return nil
    end
end

return _M

local ffi = require 'ffi'
local bit = require 'bit'
local bit_lshift = bit.lshift

ffi.cdef[[
    void openlog(const char *ident, int option, int facility);
    int setlogmask(int maskpri);
    void syslog(int priority, const char *format, ...);
    void closelog(void);
]]

-- option
local LOG_PID    = 0x01
local LOG_CONS   = 0x02
local LOG_ODELAY = 0x04
local LOG_NDELAY = 0x08
local LOG_NOWAIT = 0x10
local LOG_PERROR = 0x20

-- facility
local LOG_KERN     = bit_lshift(0,  3)
local LOG_USER     = bit_lshift(1,  3)
local LOG_MAIL     = bit_lshift(2,  3)
local LOG_DAEMON   = bit_lshift(3,  3)
local LOG_AUTH     = bit_lshift(4,  3)
local LOG_SYSLOG   = bit_lshift(5,  3)
local LOG_LPR      = bit_lshift(6,  3)
local LOG_NEWS     = bit_lshift(7,  3)
local LOG_UUCP     = bit_lshift(8,  3)
local LOG_CRON     = bit_lshift(9,  3)
local LOG_AUTHPRIV = bit_lshift(10, 3)

-- priorities
local LOG_EMERG   = 0
local LOG_ALERT   = 1
local LOG_CRIT    = 2
local LOG_ERR     = 3
local LOG_WARNING = 4
local LOG_NOTICE  = 5
local LOG_INFO    = 6
local LOG_DEBUG   = 7

local function l_openlog(ident, option, facility)
    ffi.C.openlog(ident, option, facility)
end

local _M = {}

--[[
function _M.openlog()
    l_openlog("adbid", bit.bor(LOG_PID, LOG_NDELAY), 0)
end
--]]

_M.LOG_PID    = LOG_PID
_M.LOG_CONS   = LOG_CONS
_M.LOG_ODELAY = LOG_ODELAY
_M.LOG_NDELAY = LOG_NDELAY
_M.LOG_NOWAIT = LOG_NOWAIT
_M.LOG_PERROR = LOG_PERROR

_M.LOG_USER   = LOG_USER

_M.LOG_DEBUG  = LOG_DEBUG
_M.LOG_INFO   = LOG_INFO
_M.LOG_ERR    = LOG_ERR

function _M.openlog(ident, option, facility)
    ffi.C.openlog(ident, option, facility)
end

function _M.setlogmask(log_level)
    ffi.C.setlogmask(bit_lshift(1, log_level + 1) - 1)
end

function _M.err(log_str)
    ffi.C.syslog(LOG_ERR, "%s", log_str)
end

function _M.info(log_str)
    ffi.C.syslog(LOG_INFO, "%s", log_str)
end

function _M.debug(log_str)
    ffi.C.syslog(LOG_DEBUG, "%s", log_str)
end

return _M

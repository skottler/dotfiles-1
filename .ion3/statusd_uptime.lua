-- Query every minute
if not uptime then
    statusd_uptime={ interval=60*1000 }
end

local function updateUptime()
    local f=io.popen('uptime', 'r')
    local uptime=f:read()
    
    -- 4:40PM  up 12 mins, 2 users, load averages: 0.69, 0.58, 0.32
    uptime = string.gsub(uptime, '^.+ up +', '')
    uptime = string.gsub(uptime, ', [ 0-9]+ user..*', '')

    if uptime ~= nil then 
        return string.format("[UP: %s]", uptime)
    else
        return ""
    end
end

local uptime_timer

local function send_update()
    statusd.inform("uptime", updateUptime())
    uptime_timer:set(statusd_uptime.interval, send_update)
end

uptime_timer=statusd.create_timer()
send_update()
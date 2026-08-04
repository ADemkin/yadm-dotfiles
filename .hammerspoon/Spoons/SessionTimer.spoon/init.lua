--- === SessionTimer ===
---
--- Tracks active computer usage time. Shows today's total and current session
--- duration in the menubar. Resets session after inactivity.
---
--- Usage:
---   hs.loadSpoon('SessionTimer'):start()

---@class SessionTimer
---@field name string
---@field version string
---@field author string
---@field license string
---@field idleThresholdSec number Seconds of inactivity before session ends
---@field pollIntervalSec number How often to check idle time, in seconds
---@field logFile string Path to event log file
---@field _menubar hs.menubar|nil
---@field _timer hs.timer|nil
---@field _watcher hs.caffeinate.watcher|nil
---@field _isIdle boolean
---@field _sessionStart number|nil Unix timestamp when current session started
---@field _todayTotal number Seconds of active time since 4AM
---@field _lastTickTime number|nil Unix timestamp of last timer tick
local obj = {}
obj.__index = obj

obj.name = 'SessionTimer'
obj.version = '0.1'
obj.author = 'Anton Demkin'
obj.license = 'MIT'

obj.idleThresholdSec = 180
obj.pollIntervalSec = 1
obj.logFile = os.getenv('HOME') .. '/.session_events.log'

obj._menubar = nil
obj._timer = nil
obj._watcher = nil
obj._isIdle = true
obj._sessionStart = nil
obj._todayTotal = 0
obj._lastTickTime = nil

---@enum SessionTimer.Event
local Event = {
  ACTIVE = 'ACTIVE',
  IDLE = 'IDLE',
  SLEEP = 'SLEEP',
  WAKE = 'WAKE',
}

---@param seconds number
---@return string
local function formatDuration(seconds)
  local hours = math.floor(seconds / 3600)
  local minutes = math.floor((seconds % 3600) / 60)
  if hours > 0 then
    return string.format('%dh%dm', hours, minutes)
  end
  return string.format('%dm', minutes)
end

---@return number
local function mostRecent4AM()
  local now = os.time()
  local t = os.date('*t', now)
  t.hour = 4
  t.min = 0
  t.sec = 0
  local today4am = os.time(t)
  if today4am > now then
    today4am = today4am - 86400
  end
  return today4am
end

---@param lastTime number|nil
---@param now number
---@return boolean
local function crossed4AM(lastTime, now)
  if lastTime == nil then
    return false
  end
  local boundary = mostRecent4AM()
  return lastTime < boundary and now >= boundary
end

---@param timestamp number
---@param eventType SessionTimer.Event
function obj:_logEvent(timestamp, eventType)
  local f = io.open(self.logFile, 'a')
  if f then
    f:write(tostring(math.floor(timestamp)) .. ' ' .. eventType .. '\n')
    f:flush()
    f:close()
  end
end

function obj:_trimLog()
  local f = io.open(self.logFile, 'r')
  if not f then
    return
  end
  local lines = {}
  local cutoff = os.time() - (48 * 3600)
  for line in f:lines() do
    local ts = tonumber(line:match('^(%d+)'))
    if ts and ts >= cutoff then
      table.insert(lines, line)
    end
  end
  f:close()
  local w = io.open(self.logFile, 'w')
  if w then
    w:write(table.concat(lines, '\n'))
    if #lines > 0 then
      w:write('\n')
    end
    w:close()
  end
end

function obj:_replayLog()
  local cutoff4am = mostRecent4AM()
  local events = {}

  local f = io.open(self.logFile, 'r')
  if f then
    for line in f:lines() do
      local ts, typ = line:match('^(%d+) (%u+)$')
      if ts and typ then
        table.insert(events, { time = tonumber(ts), type = typ })
      end
    end
    f:close()
  end

  local todayTotal = 0
  local lastActiveTime = nil
  local isIdle = true

  local lastSleepTime = nil

  for _, event in ipairs(events) do
    if event.time >= cutoff4am then
      if event.type == Event.ACTIVE then
        if isIdle then
          lastActiveTime = event.time
          isIdle = false
        end
        -- ignore duplicate ACTIVE
      elseif event.type == Event.IDLE then
        if lastActiveTime then
          todayTotal = todayTotal + (event.time - lastActiveTime)
        end
        lastActiveTime = nil
        lastSleepTime = nil
        isIdle = true
      elseif event.type == Event.SLEEP then
        lastSleepTime = event.time
      elseif event.type == Event.WAKE then
        if lastSleepTime and not isIdle and lastActiveTime then
          local sleepDuration = event.time - lastSleepTime
          if sleepDuration > self.idleThresholdSec then
            todayTotal = todayTotal + (lastSleepTime - lastActiveTime)
            lastActiveTime = nil
            isIdle = true
          end
        end
        lastSleepTime = nil
      end
    end
  end

  -- dangling ACTIVE: app was quit/crashed while active
  if not isIdle and lastActiveTime then
    local elapsed = os.time() - lastActiveTime
    if elapsed > self.idleThresholdSec then
      todayTotal = todayTotal + self.idleThresholdSec
      isIdle = true
      lastActiveTime = nil
    end
  end

  self._todayTotal = todayTotal
  self._isIdle = isIdle
  self._sessionStart = lastActiveTime
end

function obj:_updateMenubar()
  local currentSession = 0
  if not self._isIdle and self._sessionStart then
    currentSession = os.time() - self._sessionStart
  end
  local today = self._todayTotal + currentSession
  self._menubar:setTitle(formatDuration(today) .. ' | ' .. formatDuration(currentSession))
end

function obj:_onTick()
  local now = os.time()

  if crossed4AM(self._lastTickTime, now) then
    self:_replayLog()
  end
  self._lastTickTime = now

  local idle = hs.host.idleTime()

  if self._isIdle then
    if idle < self.idleThresholdSec then
      self:_logEvent(now, Event.ACTIVE)
      self._isIdle = false
      self._sessionStart = now
    end
  elseif idle >= self.idleThresholdSec then
    local idleStartedAt = now - idle
    if idleStartedAt < self._sessionStart then
      idleStartedAt = self._sessionStart
    end
    self:_logEvent(idleStartedAt, Event.IDLE)
    self._todayTotal = self._todayTotal + (idleStartedAt - self._sessionStart)
    self._isIdle = true
    self._sessionStart = nil
  end

  self:_updateMenubar()
end

---@param event number
function obj:_onCaffeinateEvent(event)
  if event == hs.caffeinate.watcher.systemDidSleep then
    self:_logEvent(os.time(), Event.SLEEP)
  elseif event == hs.caffeinate.watcher.systemDidWake then
    self:_logEvent(os.time(), Event.WAKE)
  end
end

---@return SessionTimer
function obj:start()
  self:_trimLog()
  self:_replayLog()
  self._lastTickTime = os.time()

  self._menubar = hs.menubar.new(true, 'sessionTimer')
  self:_updateMenubar()

  self._timer = hs.timer.doEvery(self.pollIntervalSec, function()
    self:_onTick()
  end)

  self._watcher = hs.caffeinate.watcher.new(function(ev)
    self:_onCaffeinateEvent(ev)
  end)
  self._watcher:start()

  return self
end

function obj:stop()
  if self._timer then
    self._timer:stop()
    self._timer = nil
  end
  if self._watcher then
    self._watcher:stop()
    self._watcher = nil
  end
  if not self._isIdle and self._sessionStart then
    self:_logEvent(os.time(), Event.IDLE)
  end
  if self._menubar then
    self._menubar:delete()
    self._menubar = nil
  end
end

return obj

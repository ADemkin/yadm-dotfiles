require('utils.dimmer.commands')

local api = require('utils.dimmer.api')
local state = require('utils.dimmer.state')

local M = {}

local function is_valid_time(k)
  if type(k) ~= 'string' then
    return false
  end
  local h, m = k:match('^(%d%d):(%d%d)$')
  h, m = tonumber(h), tonumber(m)
  return h and m and h >= 0 and h <= 23 and m >= 0 and m <= 59
end

local function to_minutes(k)
  local h, m = k:match('^(%d%d):(%d%d)$')
  return tonumber(h) * 60 + tonumber(m)
end

local function clamp01(x)
  if x < 0 then
    return 0
  end
  if x > 1 then
    return 1
  end
  return x
end

local function normalize_schedule(tbl)
  local out = {}

  for k, v in pairs(tbl) do
    assert(is_valid_time(k), 'invalid time key: ' .. tostring(k))
    assert(type(v) == 'number', 'schedule values must be numbers')

    table.insert(out, { to_minutes(k), clamp01(v) })
  end

  table.sort(out, function(a, b)
    return a[1] < b[1]
  end)

  return out
end

function M.setup(opts)
  opts = opts or {}

  if opts.update_interval ~= nil then
    assert(type(opts.update_interval) == 'number', 'update_interval must be a number')
    state.update_interval = opts.update_interval
  end

  if opts.override ~= nil then
    assert(type(opts.override) == 'function', 'override must be a function')
    state.override = opts.override
  end

  if opts.schedule ~= nil then
    assert(type(opts.schedule) == 'table', 'schedule must be a table')
    state.schedule = normalize_schedule(opts.schedule)
  end

  if opts.enabled ~= nil then
    state.enabled = not not opts.enabled
  end

  if state.enabled and state.schedule then
    api.start()
  else
    api.stop()
    api.apply()
  end
end

return M

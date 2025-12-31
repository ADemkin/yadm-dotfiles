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

local function normalize_k(v)
  if type(v) == 'number' then
    return { k_chroma = v, k_light = v }
  end
  return { k_chroma = v.k_chroma or 0, k_light = v.k_light or 0 }
end

local function normalize_schedule(tbl)
  local points = {}

  for k, v in pairs(tbl) do
    if not is_valid_time(k) then
      error('invalid time key: ' .. tostring(k))
    end

    local kk = normalize_k(v)
    table.insert(points, {
      minute = to_minutes(k),
      k_chroma = kk.k_chroma,
      k_light = kk.k_light,
    })
  end

  table.sort(points, function(a, b)
    return a.minute < b.minute
  end)

  return { points = points }
end

function M.setup(opts)
  opts = opts or {}

  if opts.curve ~= nil then
    assert(type(opts.curve) == 'number', 'curve must be a number')
    state.curve = opts.curve
  end

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

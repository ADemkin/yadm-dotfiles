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
    for k, v in pairs(opts.schedule) do
      assert(is_valid_time(k), 'invalid time key: ' .. tostring(k))
      assert(type(v) == 'number' or type(v) == 'table', 'schedule values must be number or {k_chroma,k_light}')
    end
    api.set_schedule(opts.schedule, state.update_interval)
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

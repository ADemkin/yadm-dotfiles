local dim = require('utils.dimmer.dim')
local state = require('utils.dimmer.state')
local tint_fn = require('utils.dimmer.tint')
local resolve = require('utils.dimmer.resolve')

local M = {}

local function apply_k(k)
  dim(tint_fn(k))
end

function M.apply()
  if not state.enabled then
    apply_k(0)
    return
  end

  -- STATIC
  if state.tint ~= nil then
    apply_k(state.tint)
    return
  end

  -- SCHEDULE
  if state.schedule then
    local v = resolve(state)
    if v ~= nil then
      apply_k(v)
    end
    return
  end

  apply_k(0)
end

function M.enable()
  state.enabled = true
  M.apply()
end

function M.disable()
  state.enabled = false
  M.apply()
end

function M.toggle()
  state.enabled = not state.enabled
  M.apply()
end

function M.set_tint(k)
  state.tint = math.max(0, math.min(1, k))
  state.enabled = true
  M.stop() -- manual override cancels schedule
  M.apply()
end

function M.clear_tint()
  state.tint = nil
  M.apply()
end

function M.get_state()
  return state
end

function M.set_schedule(schedule, interval_ms)
  state.schedule = schedule
  if interval_ms then
    state.update_interval = interval_ms
  end
end

function M.start()
  if state.timer then
    return
  end
  if not state.schedule then
    return
  end

  -- entering schedule mode clears static tint
  if state.tint ~= nil then
    state.tint = nil
  end

  state.timer = vim.loop.new_timer()
  state.timer:start(
    0,
    state.update_interval,
    vim.schedule_wrap(function()
      M.apply()
    end)
  )
end

function M.stop()
  if state.timer then
    state.timer:stop()
    state.timer:close()
    state.timer = nil
  end
end

return M

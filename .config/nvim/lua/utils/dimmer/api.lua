local dim = require('utils.dimmer.dim')
local state = require('utils.dimmer.state')
local tint_fn = require('utils.dimmer.tint')
local resolve = require('utils.dimmer.resolve')

local M = {}

local function apply_k(kc, kl)
  dim(tint_fn(kc, kl, state.curve))
end

function M.apply()
  if not state.enabled then
    apply_k(0, 0)
    return
  end

  -- STATIC MODE
  if state.tint then
    apply_k(state.tint.k_chroma, state.tint.k_light)
    return
  end

  -- SCHEDULE MODE
  if state.schedule then
    local v = resolve(state)
    if v then
      apply_k(v.k_chroma, v.k_light)
    end
    return
  end

  -- DISABLED FALLBACK
  apply_k(0, 0)
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

function M.set_tint(kc, kl, curve)
  state.tint = {
    k_chroma = math.max(0, math.min(1, kc)),
    k_light = math.max(0, math.min(1, kl)),
  }
  if curve then
    state.curve = curve
  end
  state.enabled = true
  M.stop() -- manual tint overrides schedule
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

  if state.tint then
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

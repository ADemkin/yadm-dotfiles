local dim = require('utils.dimmer.dim')
local state = require('utils.dimmer.state')
local tint = require('utils.dimmer.tint')
local resolve = require('utils.dimmer.resolve')

M = {}
function M.apply()
  if not state.enabled then
    dim(tint(0, 0, state.curve))
    return
  end
  dim(tint(state.k_chroma, state.k_light, state.curve))
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
  state.k_chroma = math.max(0, math.min(1, kc))
  state.k_light = math.max(0, math.min(1, kl))
  if curve then
    state.curve = curve
  end
  state.enabled = true
  M.apply()
end

function M.get_state()
  return state
end

function M.apply_schedule()
  if not state.schedule then
    return
  end
  local v = resolve(state.schedule)
  state.k_chroma = v.k_chroma
  state.k_light = v.k_light
  M.apply()
end

function M.set_schedule(schedule)
  state.schedule = schedule
end

function M.start()
  if state.timer then
    return
  end

  state.timer = vim.loop.new_timer()
  state.timer:start(
    0,
    state.schedule.update_interval or (60 * 1000),
    vim.schedule_wrap(function()
      M.apply_schedule()
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

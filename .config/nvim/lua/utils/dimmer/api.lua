local dim = require('utils.dimmer.dim')
local state = require('utils.dimmer.state')
local tint = require('utils.dimmer.tint')

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

return M

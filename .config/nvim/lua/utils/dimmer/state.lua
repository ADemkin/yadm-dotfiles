-- dim/state.lua

local State = {
  enabled = false,
  tint = nil, -- number ∈ [0,1] | nil (static mode)
  timer = nil,
  schedule = nil, -- normalized schedule (points)
  update_interval = 60 * 1000,
  override = nil, -- function() -> number | nil
}

return State

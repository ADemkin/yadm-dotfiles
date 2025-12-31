-- dim/state.lua

local State = {
  enabled = false,
  tint = nil, -- { k_chroma, k_light } | nil  (static mode)
  curve = 1.5,
  timer = nil,
  schedule = nil, -- normalized schedule or raw table (for now)
  update_interval = 60 * 1000,
  override = nil, -- function() -> number | {k_chroma,k_light} | nil
}

return State

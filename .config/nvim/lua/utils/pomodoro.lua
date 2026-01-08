-- dim/session.lua
--
-- Focus / break session tracker
-- No dimming logic, no schedules, no UI.
--
-- Tracks:
--   - active focus time
--   - break time
--   - session start
--   - idle detection
--
-- API:
--   session.start(timeout_ms)
--   session.stop()
--   session.get()
--
-- session.get() returns:
-- {
--   active = bool,
--   focus_ms = number,
--   break_ms = number,
--   session_start = ms,
--   last_input = ms,
-- }

local M = {}

local uv = vim.loop

local state = {
  active = false,
  timeout = 5 * 60 * 1000,

  session_start = 0,
  break_start = 0,
  last_input = 0,

  on_key = nil,
}

local function now()
  return uv.now()
end

local function reset_session(t)
  state.session_start = t
  state.break_start = t
end

local function on_key()
  local t = now()
  state.last_input = t

  -- If we were on break, resume session
  if not state.active then
    state.active = true
    state.session_start = t
  end
end

function M.start(timeout_ms)
  if state.on_key then
    return
  end

  state.timeout = timeout_ms or state.timeout

  local t = now()
  state.active = true
  state.session_start = t
  state.break_start = t
  state.last_input = t

  state.on_key = vim.on_key(on_key)
end

function M.stop()
  if state.on_key then
    vim.on_key(nil, state.on_key)
    state.on_key = nil
  end
end

function M.get()
  local t = now()

  -- detect break
  if state.active and (t - state.last_input) >= state.timeout then
    state.active = false
    state.break_start = state.last_input + state.timeout
  end

  local focus_ms = 0
  local break_ms = 0

  if state.active then
    focus_ms = t - state.session_start
    break_ms = 0
  else
    focus_ms = state.last_input - state.session_start
    break_ms = t - state.break_start
  end

  return {
    active = state.active,
    focus_ms = math.max(0, focus_ms),
    break_ms = math.max(0, break_ms),
    session_start = state.session_start,
    last_input = state.last_input,
  }
end

return M

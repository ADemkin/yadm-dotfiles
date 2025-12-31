local function now_minutes()
  local t = os.date('*t')
  return t.hour * 60 + t.min
end

local function lerp(a, b, t)
  return a + (b - a) * t
end

local function resolve(state)
  -- override wins
  if state.override then
    local ok, v = pcall(state.override)
    if ok and v ~= nil then
      return v
    end
  end

  local sched = state.schedule
  if not sched or #sched == 0 then
    return nil
  end

  local now = now_minutes()

  -- before first point
  if now <= sched[1][1] then
    return sched[1][2]
  end

  -- after last point
  if now >= sched[#sched][1] then
    return sched[#sched][2]
  end

  -- find interval
  for i = 1, #sched - 1 do
    local a = sched[i]
    local b = sched[i + 1]

    if now >= a[1] and now <= b[1] then
      local t = (now - a[1]) / (b[1] - a[1])
      return lerp(a[2], b[2], t)
    end
  end

  return sched[#sched][2]
end

return resolve

local function now_minutes()
  local t = os.date('*t')
  return t.hour * 60 + t.min
end

local function lerp(a, b, t)
  return a + (b - a) * t
end

local function interpolate(a, b, t)
  return {
    k_chroma = lerp(a.k_chroma, b.k_chroma, t),
    k_light = lerp(a.k_light, b.k_light, t),
  }
end

local function normalize_entry(v)
  if type(v) == 'number' then
    return { k_chroma = v, k_light = v }
  end
  return { k_chroma = v.k_chroma or 0, k_light = v.k_light or 0 }
end

local function resolve(state)
  -- override wins
  if state.override then
    local ok, v = pcall(state.override)
    if ok and v ~= nil then
      return normalize_entry(v)
    end
  end

  local sched = state.schedule
  if not sched or not sched.points or #sched.points == 0 then
    return nil
  end

  local now = now_minutes()
  local pts = sched.points

  if now <= pts[1].minute then
    return pts[1]
  end

  if now >= pts[#pts].minute then
    return pts[#pts]
  end

  for i = 1, #pts - 1 do
    local a, b = pts[i], pts[i + 1]
    if now >= a.minute and now <= b.minute then
      local t = (now - a.minute) / (b.minute - a.minute)
      return interpolate(a, b, t)
    end
  end

  return pts[#pts]
end

return resolve

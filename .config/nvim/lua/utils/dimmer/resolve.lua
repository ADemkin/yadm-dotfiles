local function time_to_minutes(t)
  local h, m = t:match('^(%d%d):(%d%d)$')
  return tonumber(h) * 60 + tonumber(m)
end

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
  -- override wins (schedule mode only; static handled in api)
  if state.override then
    local ok, v = pcall(state.override)
    if ok and v ~= nil then
      return normalize_entry(v)
    end
  end

  local schedule = state.schedule
  if not schedule then
    return nil
  end

  local now = now_minutes()
  local points = {}

  for time, v in pairs(schedule) do
    local t = time_to_minutes(time)
    if t then
      table.insert(points, { t = t, v = normalize_entry(v) })
    end
  end

  table.sort(points, function(a, b)
    return a.t < b.t
  end)
  if #points == 0 then
    return nil
  end

  if now <= points[1].t then
    return points[1].v
  end
  if now >= points[#points].t then
    return points[#points].v
  end

  for i = 1, #points - 1 do
    local a, b = points[i], points[i + 1]
    if now >= a.t and now <= b.t then
      local t = (now - a.t) / (b.t - a.t)
      return interpolate(a.v, b.v, t)
    end
  end

  return points[#points].v
end

return resolve

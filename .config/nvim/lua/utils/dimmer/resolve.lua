local function time_to_minutes(t)
  local h, m = t:match('(%d+):(%d+)')
  return tonumber(h) * 60 + tonumber(m)
end

local function now_minutes()
  local t = os.date('*t')
  return t.hour * 60 + t.min
end

local function now_weekday_number()
  return tonumber(os.date('%s'))
end

local function now_weekday_string()
  return os.date('%A')
end

local function is_weekend()
  local w = tonumber(os.date('%w')) -- 0 = Sunday
  return w == 0 or w == 6
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
    return {
      k_chroma = v,
      k_light = v,
    }
  end

  return {
    k_chroma = v.k_chroma or 0,
    k_light = v.k_light or 0,
  }
end

local function resolve(schedule)
  if schedule.days then
    local entry = schedule.days[now_weekday_number()] or schedule.days[now_weekday_string()]
    if entry then
      return normalize_entry(entry)
    end
  end

  local now = now_minutes()
  local points = {}

  for time, v in pairs(schedule.daily) do
    table.insert(points, {
      t = time_to_minutes(time),
      v = normalize_entry(v),
    })
  end

  table.sort(points, function(a, b)
    return a.t < b.t
  end)

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
end

return resolve

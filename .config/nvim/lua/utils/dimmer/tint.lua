-- dim/tint.lua

-- Global perceptual curve.
-- Increase → steeper falloff (more night-shift like)
-- Decrease → more linear
DIM_CURVE = 1.5

local function tint_lspace(amount)
  local k = math.max(0, math.min(1, amount))

  local function ease(x)
    return x ^ DIM_CURVE
  end

  return function(hex)
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)

    -- perceptual luminance (sRGB / Rec.709)
    local l = 0.2126 * r + 0.7152 * g + 0.0722 * b

    local kk = ease(k)

    -- chroma removal + contrast compression together
    r = l + (r - l) * (1 - kk)
    g = l + (g - l) * (1 - kk)
    b = l + (b - l) * (1 - kk)

    local function clamp(x)
      x = math.floor(x + 0.5)
      if x < 0 then
        return 0
      end
      if x > 255 then
        return 255
      end
      return x
    end

    return string.format('#%02x%02x%02x', clamp(r), clamp(g), clamp(b))
  end
end

return tint_lspace

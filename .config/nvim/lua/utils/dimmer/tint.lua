--- k_chroma, k_light ∈ [0, 1]
--- curve > 0  (1 = linear, 2 = quadratic, ~1.5 = nice default)
local function tint_lspace(k_chroma, k_light, curve)
  curve = curve or 1.5

  local function ease(x)
    return x ^ curve
  end

  return function(hex)
    local r = tonumber(hex:sub(2, 3), 16)
    local g = tonumber(hex:sub(4, 5), 16)
    local b = tonumber(hex:sub(6, 7), 16)

    -- perceptual luminance (sRGB / Rec.709)
    local l = 0.2126 * r + 0.7152 * g + 0.0722 * b

    local kc = ease(k_chroma)
    local kl = ease(k_light)

    -- remove chroma (toward gray of same luminance)
    r = r + (l - r) * kc
    g = g + (l - g) * kc
    b = b + (l - b) * kc

    -- compress lightness contrast
    r = l + (r - l) * (1 - kl)
    g = l + (g - l) * (1 - kl)
    b = l + (b - l) * (1 - kl)

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

local original_hl = nil

local function hex_to_rgb(hex)
  hex = hex:gsub('#', '')
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

local function rgb_to_int(r, g, b)
  return r * 65536 + g * 256 + b
end

local function snapshot_highlights()
  original_hl = {}
  for _, name in ipairs(vim.fn.getcompletion('', 'highlight')) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok and hl then
      original_hl[name] = hl
    end
  end
end

--- Mutate ALL highlight groups in-place (idempotent & reversible)
--- @param fn fun(hex:string):string|nil
local function dim_highlights(fn)
  if not original_hl then
    snapshot_highlights()
  end

  for name, hl in pairs(original_hl) do
    local new = {}

    for _, key in ipairs({ 'fg', 'bg', 'sp' }) do
      local v = hl[key]
      if type(v) == 'number' then
        local hex = string.format('#%06x', v)
        local out = fn(hex)
        if out then
          local r, g, b = hex_to_rgb(out)
          new[key] = rgb_to_int(r, g, b)
        end
      end
    end

    for _, attr in ipairs({
      'bold',
      'italic',
      'underline',
      'undercurl',
      'reverse',
      'strikethrough',
    }) do
      if hl[attr] ~= nil then
        new[attr] = hl[attr]
      end
    end

    if next(new) then
      vim.api.nvim_set_hl(0, name, new)
    end
  end
end

return dim_highlights

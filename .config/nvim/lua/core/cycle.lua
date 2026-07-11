--- Cycle patterns for <C-a>/<C-x> per filetype.
--- Each filetype maps to a list of pattern groups; each group is a list of strings that cycle.

---@alias CycleGroup string[]
---@alias CyclePatterns CycleGroup[]
---@alias vim.filetype string
---@alias CycleConfig { [vim.filetype]: CyclePatterns }

---@enum CycleDirection
local Direction = {
  increment = 'increment',
  decrement = 'decrement',
}

---@class CycleMatch
---@field group CycleGroup
---@field index integer  index of the matched entry within the group
---@field start integer  0-based start column of the match in the line
---@field value string   the matched string

---@param match CycleMatch
---@param direction CycleDirection
---@return string
local function match_next(match, direction)
  local step = (direction == Direction.increment) and 1 or -1
  local next_index = ((match.index - 1 + step + #match.group) % #match.group) + 1
  return match.group[next_index]
end

---@type CycleConfig
local config = {}

--- Find the first pattern group that has any entry present in the line.
--- Within a matching group, returns the entry found earliest in the line.
---@param line string
---@param patterns CyclePatterns
---@return CycleMatch?
local function find_match(line, patterns)
  for _, group in ipairs(patterns) do
    local match ---@type CycleMatch?
    for index, pattern in ipairs(group) do
      local start = line:find(pattern, 1, true)
      if start and (match == nil or start - 1 < match.start) then
        match = { group = group, index = index, start = start - 1, value = pattern }
      end
    end
    if match then
      return match
    end
  end
end

---@param direction CycleDirection
local function fallback(direction)
  local key = direction == Direction.increment and '<C-a>' or '<C-x>'
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), 'n', false)
end

---@param direction CycleDirection
local function cycle(direction)
  local patterns = config[vim.bo.filetype]
  if not patterns then
    fallback(direction)
    return
  end
  local line = vim.api.nvim_get_current_line()
  local match = find_match(line, patterns)
  if not match then
    fallback(direction)
    return
  end
  local replacement = match_next(match, direction)
  local new_line = line:sub(1, match.start) .. replacement .. line:sub(match.start + #match.value + 1)
  vim.api.nvim_set_current_line(new_line)
  -- Shift cursor only if it sits at or after the matched pattern
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1], cursor[2]
  local new_col = (col >= match.start) and math.max(0, col + #replacement - #match.value) or col
  vim.api.nvim_win_set_cursor(0, { row, new_col })
end

--- Build a validated copy of the config, warning about and skipping invalid groups.
---@param opts CycleConfig
---@return CycleConfig
local function build_config(opts)
  local result = {}
  for filetype, patterns in pairs(opts) do
    local valid_patterns = {}
    for gi, group in ipairs(patterns) do
      if #group < 2 then
        vim.notify(('cycle: filetype %q group %d has fewer than 2 entries, skipping'):format(filetype, gi), vim.log.levels.WARN)
      else
        table.insert(valid_patterns, group)
      end
    end
    if #valid_patterns > 0 then
      result[filetype] = valid_patterns
    end
  end
  return result
end

local M = {}

--- Increment the cycle pattern on the current line (or fall back to built-in <C-a>).
function M.increment()
  cycle(Direction.increment)
end

--- Decrement the cycle pattern on the current line (or fall back to built-in <C-x>).
function M.decrement()
  cycle(Direction.decrement)
end

---@param opts CycleConfig?
function M.setup(opts)
  config = build_config(opts or {})
  local augroup = vim.api.nvim_create_augroup('Cycle', { clear = true })
  for filetype in pairs(config) do
    vim.api.nvim_create_autocmd('FileType', {
      pattern = filetype,
      group = augroup,
      callback = function(event)
        vim.keymap.set('n', '<C-a>', function()
          M.increment()
        end, { buffer = event.buf, desc = 'Cycle increment' })
        vim.keymap.set('n', '<C-x>', function()
          M.decrement()
        end, { buffer = event.buf, desc = 'Cycle decrement' })
      end,
    })
  end
end

return M

local SESSION_MIN_LENGTH = 20
local SESSION_MAX_LENGTH = 40

--- @param value number: from 0.0 to 1.0
--- @param time_ms number: time in ms
--- @return number: from 0.0 to 1.0
local function pomodoro_ramp(value, time_ms)
  local break_should_start_ms = SESSION_MIN_LENGTH * 60 * 1000
  local break_should_end_ms = SESSION_MAX_LENGTH * 60 * 1000
  if time_ms <= break_should_start_ms then
    return value
  end
  if time_ms >= break_should_end_ms then
    return 1.0
  end
  local k = (time_ms - break_should_start_ms) / (break_should_end_ms - break_should_start_ms)
  return value + k * (1.0 - value)
end

return {
  -- local development:
  'dim.nvim',
  dev = true,
  lazy = false,
  priority = 1000,
  dependencies = {
    { 'nvim-tree/nvim-web-devicons' },
  },
  -- public plugin
  -- 'ademkin/dim.nvim',
  config = function()
    local pomodoro = require('utils.pomodoro')
    pomodoro.start(1 * 60 * 1000) -- break time
    ---@type DimOpts
    require('dim').setup({
      enabled = true,
      -- update_interval = 1 * 60 * 1000, -- once a minute
      update_interval = 1 * 1000, -- once a second
      schedule = {
        ['04:00'] = 1.0,
        ['08:00'] = 0,
        ['16:00'] = 0,
        ['17:00'] = 0.3,
        ['18:00'] = 0.7,
        ['20:00'] = 1.0,
      },
      ---@type Override
      override = function(amount)
        local focus_ms = pomodoro.get().focus_ms
        amount = pomodoro_ramp(amount, focus_ms)
        local month = tonumber(os.date('%m'))
        local day = tonumber(os.date('%d'))
        if month == 1 and day < 12 then
          return math.max(amount, 0.5)
        end
        local weekday = os.date('%a')
        if weekday == 'Sunday' or weekday == 'Saturday' then
          return math.max(0.8, amount)
        end
      end,
    })
  end,
}

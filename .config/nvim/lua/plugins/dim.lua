return {
  -- local development:
  'dim.nvim',
  dev = true,
  lazy = false,
  priority = 1000,
  -- public plugin
  -- 'ademkin/dim.nvim',
  opts = {
    enabled = true,
    update_interval = 15 * 1000,
    schedule = {
      ['04:00'] = 1.0,
      ['08:00'] = 0,
      ['16:00'] = 0,
      ['17:00'] = 0.3,
      ['18:00'] = 0.7,
      ['20:00'] = 1.0,
    },
    override = function(amount)
      local month = tonumber(os.date('%m'))
      local day = tonumber(os.date('%d'))
      if month == 1 and day < 12 then
        return math.max(amount, 0.5)
      end
      local weekday = os.date('%a')
      if weekday == 'Sunday' or weekday == 'Saturday' then
        return 0.9
      end
    end,
  },
}

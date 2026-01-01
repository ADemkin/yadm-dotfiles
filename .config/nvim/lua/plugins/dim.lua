return {
  -- local development:
  --   'dim.nvim',
  --   dev = true,
  'ademkin/dim.nvim',
  opts = {
    enabled = true,
    schedule = {
      ['04:00'] = 1.0,
      ['08:00'] = 0,
      ['16:00'] = 0,
      ['17:00'] = 0.3,
      ['18:00'] = 0.7,
      ['20:00'] = 1.0,
    },
    override = function()
      local month = os.date('%m')
      local day = os.date('%d')
      if month == 1 and day < 11 then
        return 0.6
      end

      local weekday = os.date('%a')
      if weekday == 'Sunday' or weekday == 'Saturday' then
        return 0.9
      end
    end,
  },
}

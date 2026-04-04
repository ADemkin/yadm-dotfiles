-- lazy.nvim: dev=true (loads from ~/code/dim.nvim), priority=1000
-- vim.pack does not support local/dev plugins.
-- Instead, prepend the local path directly to runtimepath.
-- Alternatively, place/symlink dim.nvim into ~/.local/share/nvim/site/pack/dev/opt/dim.nvim
-- and use: vim.cmd.packadd('dim.nvim')

-- local dev_path = vim.fn.expand('~/code/dim.nvim')
-- if vim.fn.isdirectory(dev_path) ~= 1 then
--   return -- skip if not available
-- end

-- -- Defer: enabled=false so it doesn't affect first frame, and it's slow to load (~3.7ms)
-- vim.opt.rtp:prepend(dev_path)

-- vim.schedule(function()
--   local SESSION_MIN_LENGTH = 20
--   local SESSION_MAX_LENGTH = 40

--   local function pomodoro_ramp(value, time_ms)
--     local break_should_start_ms = SESSION_MIN_LENGTH * 60 * 1000
--     local break_should_end_ms = SESSION_MAX_LENGTH * 60 * 1000
--     if time_ms <= break_should_start_ms then
--       return value
--     end
--     if time_ms >= break_should_end_ms then
--       return 1.0
--     end
--     local k = (time_ms - break_should_start_ms) / (break_should_end_ms - break_should_start_ms)
--     return value + k * (1.0 - value)
--   end

--   local pomodoro = require('utils.pomodoro')
--   pomodoro.start(1 * 60 * 1000)

--   require('dim').setup({
--     enabled = false,
--     update_interval = 15 * 1000,
--     schedule = {
--       ['04:00'] = 1.0,
--       ['08:00'] = 0,
--       ['16:00'] = 0,
--       ['17:00'] = 0.3,
--       ['18:00'] = 0.7,
--       ['20:00'] = 1.0,
--     },
--     override = function(amount)
--       local focus_ms = pomodoro.get().focus_ms
--       amount = pomodoro_ramp(amount, focus_ms)
--       local month = tonumber(os.date('%m'))
--       local day = tonumber(os.date('%d'))
--       if month == 1 and day < 12 then
--         return math.max(amount, 0.5)
--       end
--       local weekday = os.date('%a')
--       if weekday == 'Sunday' or weekday == 'Saturday' then
--         return math.max(0.8, amount)
--       end
--     end,
--   })
-- end)

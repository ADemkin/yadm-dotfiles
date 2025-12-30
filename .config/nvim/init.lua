require('core.options')
require('core.keymaps')
require('core.search')
require('core.ui')
require('core.events')
require('core.spell')

--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- Appearance
  require('plugins/lualine'),
  require('themes/gruvbox'),

  -- lightweight plugins
  require('plugins/tpope'),
  require('plugins/tmux'),
  require('plugins/indentline'),
  require('plugins/argwrap'),
  require('plugins/wilder'), -- maybe this one is replaced by blink.cmp?
  require('plugins/mark'),
  require('plugins/flash'),
  require('plugins/toggleterm'),
  require('plugins/colors'),
  require('plugins/readline'),
  require('plugins/cycle'),
  require('plugins/quickfix'),
  require('plugins/coverage'),
  -- require('plugins/autopairs'),
  -- require('plugins/hardtime'),
  require('plugins/git'),

  -- LSP, lint, format
  require('plugins/lsp'),
  require('plugins/format'),
  require('plugins/lint'),
  require('plugins/autocomplete'),

  -- Heavyweight plugins
  require('plugins/neotree'),
  require('plugins/treesitter'),
  require('plugins/treesitter-context'),
  require('plugins/textobjects'),
  require('plugins/telescope'),
  require('plugins/ai'),
  require('plugins/code-navigation'),
  require('plugins/neotest'),
  require('plugins/markdown'),

  -- auto f-string
  {
    'chrisgrieser/nvim-puppeteer',
    lazy = false,
  },
  -- time tracker
  {
    'ptdewey/pendulum-nvim',
    config = function()
      require('pendulum').setup({
        time_zone = 'EET',
        time_format = '24h',
      })
    end,
  },
})

local schedule = {
  interval_ms = 1000,
  daily = {
    ['08:00'] = 0.0,
    ['16:00'] = 0.1,
    ['17:00'] = 0.2,
    ['17:30'] = 0.3,
    ['17:45'] = 0.4,
    ['18:00'] = 0.7,
    ['19:00'] = 0.8,
    ['21:00'] = 0.9,
  },
  days = {
    ['Friday'] = { -- stop working on Friday earlier
      ['08:00'] = 0.0,
      ['16:00'] = 0.0,
      ['17:00'] = 0.8,
      ['18:00'] = 1.0,
    },
    ['Saturday'] = { k_chroma = 0.8, k_light = 0.7 },
    ['Sunday'] = 1.0,
  },
}
local opts = {
  enabled = true,
  curve = 1.5,
  dim = schedule,
}
-- require('utils.dimmer.setup').setup(opts)
local dimmer = require('utils.dimmer.main')
dimmer.set_schedule(schedule)
dimmer.start()

-- TODO: move to keymaps
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.py',
  callback = function()
    vim.keymap.set('n', '<leader>yt', require('core.terminal').run_single_test, { noremap = true, desc = 'Run current pytest test in terminal' })
    vim.keymap.set('n', '<leader>yf', require('core.terminal').run_module_test, { noremap = true, desc = 'Run current pytest module tests in terminal' })
    vim.keymap.set('n', '<C-p>', require('python.try_wrapper').toggle_try, { noremap = true, silent = true })
  end,
})

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
  require('plugins/dim'),

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
  -- require('plugins/notes'),

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
  -- require('plugins/ai'),
  require('plugins/code-navigation'),
  require('plugins/neotest'),
  require('plugins/markdown'),
  require('plugins/qol'),

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
}, {
  dev = { path = '~/code' },
})

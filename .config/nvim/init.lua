require('core.keymaps')
require('core.options')
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
  require('plugins/tmux'), -- tmux integration and panel re sizing
  require('plugins/indentline'), -- indent guides
  require('plugins/argwrap'), -- arguments wrapper
  require('plugins/wilder'), -- command line completion
  require('plugins/mark'), -- highlights
  require('plugins/flash'), -- S motion
  require('plugins/toggleterm'), -- terminal integration
  require('plugins/gitsigns'), -- Git integration
  require('plugins/colors'), -- display hex colors
  require('plugins/readline'), -- readline bindings for command line
  require('plugins/cycle'), -- cycle through values with <C-a> and <C-x>

  -- Heavyweight plugins
  require('plugins/neotree'),
  require('plugins/autocomplete'),
  require('plugins/autopairs'),
  require('plugins/treesitter'),
  require('plugins/treesitter-context'),
  require('plugins/textobjects'),
  require('plugins/lsp'),
  require('plugins/autoformat'),
  require('plugins/telescope'),
  require('plugins/ai'),
  require('plugins/quickfix'),
  require('plugins/code-navigation'),
  require('plugins/coverage'), -- show test coverage in numbercolumn
  require('plugins/db'), -- SQL integration
  -- require('plugins/neotest'),

  {
    'm4xshen/hardtime.nvim',
    lazy = false,
    dependencies = { 'MunifTanjim/nui.nvim' },
    opts = {},
  },
})

require('core.terminal')

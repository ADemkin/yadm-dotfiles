require('core.keymaps')
require('core.options')
require('core.search')
require('core.ui')
require('core.events')

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
  require('themes/gruvbox'),

  -- lightweight plugins
  require('plugins/tpope'),
  require('plugins/tmux'), -- tmux integration and panel resizing
  require('plugins/readline'), -- readline bindings for command line
  require('plugins/indentline'), -- indent guides
  require('plugins/argwrap'), -- arguments wrapper
  require('plugins/wilder'), -- command line completion
  require('plugins/mark'), -- highlights
  require('plugins/lualine'), -- status line
  require('plugins/flash'), -- S motion
  require('plugins/toggleterm'), -- terminal integration
  require('plugins/gitsigns'), -- Git integration
  require('plugins/autopairs'), -- autopairs that doesn't make me barf

  -- Heavyweight plugins
  require('plugins/neotree'),
  require('plugins/autocomplete'),
  require('plugins/treesitter'),
  require('plugins/treesitter-context'),
  require('plugins/lsp'),
  require('plugins/null-ls'),
  require('plugins/telescope'),
  require('plugins/ai'),
})

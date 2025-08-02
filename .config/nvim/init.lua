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
  -- Appearance
  require('plugins/lualine'),
  require('themes/gruvbox'),

  -- lightweight plugins
  require('plugins/tpope'),
  require('plugins/tmux'),       -- tmux integration and panel resizing
  require('plugins/indentline'), -- indent guides
  require('plugins/argwrap'),    -- arguments wrapper
  require('plugins/wilder'),     -- command line completion
  require('plugins/mark'),       -- highlights
  require('plugins/flash'),      -- S motion
  require('plugins/toggleterm'), -- terminal integration
  require('plugins/gitsigns'),   -- Git integration
  require('plugins/autopairs'),  -- autopairs that doesn't make me barf
  require('plugins/quickfix'),   -- quickfix enhancements

  -- Heavyweight plugins
  require('plugins/neotree'),            -- file explorer
  require('plugins/autocomplete'),       -- autocompletion
  require('plugins/treesitter'),         -- syntax highlighting and more
  require('plugins/treesitter-context'), -- show current function/class
  require('plugins/treesitter-textobjects'),
  require('plugins/lsp'),                -- LSP support
  require('plugins/null-ls'),            -- formatting and diagnostics
  require('plugins/telescope'),          -- fuzzy finder
  require('plugins/ai'),                 -- AI integration
  require('plugins/database'),           -- database
  require('plugins/trouble'),            -- fancy quickfix

  require('plugins/readline'),           -- readline bindings for command line
})

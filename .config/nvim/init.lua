require('core.options')
require('core.keymaps')
require('core.search')
require('core.ui')
require('core.events')
require('core.spell')

require('core.cycle').setup({
  markdown = {
    { '# ', '## ', '### ', '#### ', '##### ', '###### ' },
    { '[ ] ', '[x] ' },
  },
})

--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
-- local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
-- if not (vim.uv or vim.loop).fs_stat(lazypath) then
--   local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
--   local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
--   if vim.v.shell_error ~= 0 then
--     error('Error cloning lazy.nvim:\n' .. out)
--   end
-- end
-- vim.opt.rtp:prepend(lazypath)

vim.pack.add({ 'https://github.com/folke/lazy.nvim.git' }, { confirm = false })

require('lazy').setup({
  -- Appearance
  -- require('themes/gruvbox'),
  require('themes/monokai'),
  require('plugins/lualine'),
  -- require('themes/monokai-night'),
  -- require('plugins/dim'),

  -- lightweight plugins
  require('plugins/tpope'),
  require('plugins/git'),
  require('plugins/tmux'),
  require('plugins/toggleterm'),
  require('plugins/indentline'),
  -- require('plugins/wilder'), -- maybe this one is replaced by blink.cmp?
  require('plugins/mark'),
  require('plugins/flash'),
  -- require('plugins/colors'),
  require('plugins/readline'),
  require('plugins/quickfix'),
  require('plugins/coverage'),
  -- require('plugins/autopairs'),
  require('plugins/align'),

  -- LSP, lint, format
  require('plugins/lsp'),
  require('plugins/format'),
  require('plugins/lint'),
  require('plugins/autocomplete'),

  -- treesitter
  require('plugins/treesitter'),
  require('plugins/textobjects'),
  require('plugins/argwrap'),

  -- Heavyweight plugins
  require('plugins/neotree'),
  require('plugins/breadcrumbs'),
  require('plugins/telescope'),
  require('plugins/navigation'),
  require('plugins/neotest'),
  require('plugins/markdown'),
  require('plugins/refactoring'),
  require('plugins/startscreen'),
  require('plugins/claude'),
  require('plugins/csv'),

  -- which key - temporary ?
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      delay = 300,
      triggers = {
        { '<leader>', mode = { 'n', 'v' } },
        { 'g', mode = { 'n', 'v' } },
        { 't', mode = { 'n', 'v' } },
      },
    },
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show({ global = false })
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
  },

  -- time tracker
  -- {
  --   'ptdewey/pendulum-nvim',
  --   config = function()
  --     require('pendulum').setup({
  --       time_zone = 'EET',
  --       time_format = '24h',
  --     })
  --   end,
  -- },

  -- camelCase and snake_case motions
  -- {
  --   'chrisgrieser/nvim-spider',
  --   keys = {
  --     { 'w', "<cmd>lua require('spider').motion('w')<CR>", mode = { 'n', 'o', 'x' } },
  --     { 'e', "<cmd>lua require('spider').motion('e')<CR>", mode = { 'n', 'o', 'x' } },
  --     { 'b', "<cmd>lua require('spider').motion('b')<CR>", mode = { 'n', 'o', 'x' } },
  --     { 'ge', "<cmd>lua require('spider').motion('ge')<CR>", mode = { 'n', 'o', 'x' } },
  --   },
  -- },

  -- better inline diagnostics
  -- {
  --   'rachartier/tiny-inline-diagnostic.nvim',
  --   event = 'VeryLazy',
  --   priority = 1000,
  --   config = function()
  --     require('tiny-inline-diagnostic').setup()
  --     vim.diagnostic.config({ virtual_text = false }) -- Disable Neovim's default virtual text diagnostics
  --   end,
  -- },

  -- another better inline diagnostics
  -- {
  --   'sontungexpt/better-diagnostic-virtual-text',
  --   event = 'LspAttach',
  --   config = function()
  --     require('better-diagnostic-virtual-text').setup()
  --   end,
  -- },

  -- preserve indent level on paste
  -- {
  --   'nemanjamalesija/smart-paste.nvim',
  --   event = 'VeryLazy',
  --   config = true,
  -- },

  -- show how many times search is found
  {
    'https://github.com/google/vim-searchindex.git',
  },
}, {
  dev = { path = '~/code' },
})

require('core.options')
require('core.keymaps')
require('core.search')
require('core.ui')
require('core.indent')
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
  require('themes/monokai'),
  require('plugins/lualine'),

  -- lightweight plugins
  require('plugins/tpope'),
  require('plugins/git'),
  require('plugins/tmux'),
  require('plugins/toggleterm'),
  require('plugins/indentline'),
  require('plugins/mark'),
  require('plugins/flash'),
  -- require('plugins/colors'),
  require('plugins/readline'),
  require('plugins/quickfix'),
  require('plugins/coverage'),
  require('plugins/align'),
  require('plugins/whichkey'),

  -- LSP, lint, format
  require('plugins/lsp'),
  require('plugins/format'),
  require('plugins/lint'),
  require('plugins/autocomplete'),

  -- treesitter
  require('plugins/treesitter'),
  require('plugins/textobjects'),
  require('plugins/argwrap'),

  -- AI
  -- require('plugins/claude'),
  require('plugins/opencode'),

  -- Heavyweight plugins
  require('plugins/neotree'),
  require('plugins/breadcrumbs'),
  require('plugins/telescope'),
  require('plugins/navigation'),
  require('plugins/neotest'),
  require('plugins/markdown'),
  require('plugins/refactoring'),
  -- require('plugins/startscreen'),
  require('plugins/csv'),
}, {
  dev = { path = '~/code' },
})

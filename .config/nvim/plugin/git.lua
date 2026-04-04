vim.schedule(function()
  vim.pack.add({
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/purarue/yadm-git.vim',
    'https://github.com/rhysd/conflict-marker.vim',
    'https://github.com/lewis6991/gitsigns.nvim',
  })

  vim.g.yadm_git_fugitive_enabled = 1

  require('gitsigns').setup({
    signcolumn = false,
    numhl = true,
    linehl = false,
  })

  vim.keymap.set('n', '<C-g>', '<cmd>Git<cr>')
  vim.keymap.set('n', 'tm', '<cmd>Git mergetool<cr>')
  vim.keymap.set('n', 'tj', '<cmd>Gitsigns next_hunk<CR>')
  vim.keymap.set('n', 'tk', '<cmd>Gitsigns prev_hunk<CR>')
  vim.keymap.set('n', ']h', '<cmd>Gitsigns next_hunk<CR>')
  vim.keymap.set('n', '[h', '<cmd>Gitsigns prev_hunk<CR>')
  vim.keymap.set('n', 'tu', '<cmd>Gitsigns reset_hunk<CR>')

  -- snacks.nvim is already loaded in claude.lua; just add the keymap
  vim.keymap.set('n', 'to', function()
    require('snacks.gitbrowse').open()
  end)
end)

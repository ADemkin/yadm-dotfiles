return {
  {
    'tpope/vim-fugitive',
    command = 'Git',
    config = function()
      vim.keymap.set('n', '<C-g>', ':Git<CR>', { noremap = true, silent = true })
    end,
  },
  {
    'rhysd/conflict-marker.vim',
    event = 'VeryLazy',
  }, -- ct / co / cb git conflict resolver
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    config = function()
      require('gitsigns').setup({
        signcolumn = false,
        numhl = true,
        linehl = false,
      })
      local opts = { noremap = true, silent = true }
      vim.keymap.set('n', 'tj', ':Gitsigns next_hunk<CR>', opts)
      vim.keymap.set('n', 'tk', ':Gitsigns prev_hunk<CR>', opts)
      vim.keymap.set('n', ']h', ':Gitsigns next_hunk<CR>', opts)
      vim.keymap.set('n', '[h', ':Gitsigns prev_hunk<CR>', opts)
      vim.keymap.set('n', 'tu', ':Gitsigns reset_hunk<CR>', opts)
    end,
  },
}

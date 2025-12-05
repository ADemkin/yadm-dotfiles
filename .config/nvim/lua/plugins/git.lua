return {
  {
    'tpope/vim-fugitive',
    command = 'Git',
    keys = {
      { '<C-g>', '<cmd>Git<cr>' },
    },
  },
  {
    'rhysd/conflict-marker.vim',
    event = 'VeryLazy',
  }, -- ct / co / cb git conflict resolver
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    opts = {
      signcolumn = false,
      numhl = true,
      linehl = false,
    },
    keys = {
      { 'tj', '<cmd>Gitsigns next_hunk<CR>' },
      { 'tk', '<cmd>Gitsigns prev_hunk<CR>' },
      { ']h', '<cmd>Gitsigns next_hunk<CR>' },
      { '[h', '<cmd>Gitsigns prev_hunk<CR>' },
      { 'tu', '<cmd>Gitsigns reset_hunk<CR>' },
    },
  },
}

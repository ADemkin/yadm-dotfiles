return {
  {
    'tpope/vim-fugitive',
    event = 'BufWinEnter',
    keys = {
      { '<C-g>', '<cmd>Git<cr>' },
    },
  },
  {
    -- allow fugitive to work with yadm
    'purarue/yadm-git.vim',
    event = 'BufWinEnter',
    config = function()
      vim.g.yadm_git_fugitive_enabled = 1
    end,
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
  {
    'esmuellert/vscode-diff.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    cmd = 'CodeDiff',
  },
  {
    'folke/snacks.nvim',
    keys = {
      {
        'to',
        function()
          ---@param opts? snacks.gitbrowse.Config
          require('snacks.gitbrowse').open()
        end,
      },
    },
  },
}

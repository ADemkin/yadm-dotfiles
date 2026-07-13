return {
  -- fancy diagnostics in quickfix list
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    cmd = 'Trouble',
    keys = {
      {
        '<leader>d',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Fancy diagnostics',
      },
    },
    opts = {
      modes = {
        symbols = {
          win = {
            type = 'split',
            relative = 'win',
            position = 'right',
            size = 0.25,
          },
        },
      },
    },
  },
  -- quickfix list with edit
  {
    'stevearc/quicker.nvim',
    ft = 'qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
}

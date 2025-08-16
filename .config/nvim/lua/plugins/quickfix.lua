return {
  {
    'stevearc/quicker.nvim',
    event = 'FileType qf',
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      edit = {
        enabled = false,
      },
    },
  },
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
}

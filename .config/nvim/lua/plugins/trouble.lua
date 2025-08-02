return {
  'folke/trouble.nvim',
  event = 'VeryLazy',
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = 'Trouble',
  keys = {
    {
      '<leader>d',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Fancy diagnostics',
    },
    {
      '<leader>n',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = '[N]avigate module',
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
}

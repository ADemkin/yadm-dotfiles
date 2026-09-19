return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 200,
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
}

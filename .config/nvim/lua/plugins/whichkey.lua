return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 800,
    -- triggers = {
    --   { '<leader>', mode = { 'n', 'v' } },
    --   { 'g', mode = { 'n', 'v' } },
    --   { 't', mode = { 'n', 'v' } },
    --   { '[', mode = { 'n' } },
    --   { ']', mode = { 'n' } },
    --   { '<C-w>', mode = { 'n' } },
    -- },
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

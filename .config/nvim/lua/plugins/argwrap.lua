return {
  'Wansmer/treesj',
  event = 'VeryLazy',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  opts = {
    use_default_keymaps = false,
    max_join_length = 512,
  },
  keys = {
    {
      '<leader>j',
      function()
        require('treesj').toggle()
      end,
    },
    {
      '<leader>J',
      function()
        require('treesj').toggle({ split = { recursive = true } })
      end,
    },
  },
}

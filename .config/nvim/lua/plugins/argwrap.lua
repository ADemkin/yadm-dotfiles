return {
  'Wansmer/treesj',
  event = 'VeryLazy',
  -- keys = { '', '', '' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesj').setup({
      use_default_keymaps = false,
      max_join_length = 512, -- max length of a line to be joined
    })
    vim.keymap.set('n', '<leader>j', function()
      require('treesj').toggle()
    end)
    vim.keymap.set('n', '<leader>J', function()
      require('treesj').toggle({ split = { recursive = true } })
    end)
  end,
}

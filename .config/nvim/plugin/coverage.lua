vim.schedule(function()
  vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/andythigpen/nvim-coverage',
  })

  require('coverage').setup({
    auto_reload = true,
  })

  vim.keymap.set('n', 'tc', '<cmd>Coverage<cr>', { desc = 'Toggle coverage' })
end)

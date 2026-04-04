vim.schedule(function()
  vim.pack.add({
    -- plenary and nvim-treesitter loaded in other files; vim.pack handles duplicates
    'https://github.com/ThePrimeagen/refactoring.nvim',
  })

  require('refactoring').setup({})

  vim.keymap.set('n', '<leader>r', function()
    require('refactoring').select_refactor()
  end)
end)

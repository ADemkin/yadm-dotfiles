vim.schedule(function()
  vim.pack.add({
    'https://github.com/SmiteshP/nvim-navic',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/utilyre/barbecue.nvim',
  })

  require('barbecue').setup({
    exclude_filetypes = { 'gitcommit' },
  })
end)

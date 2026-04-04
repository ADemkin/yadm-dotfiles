vim.schedule(function()
  vim.pack.add({
    -- nvim-treesitter and nvim-web-devicons loaded in other files; vim.pack handles duplicates
    'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  })

  require('render-markdown').setup({
    sign = { enabled = false },
  })
end)

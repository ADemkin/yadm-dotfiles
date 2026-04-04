vim.schedule(function()
  vim.pack.add({ 'https://github.com/echasnovski/mini.align' })

  require('mini.align').setup({
    mappings = {
      start = 'geA',
      start_with_preview = 'gea',
    },
  })
end)

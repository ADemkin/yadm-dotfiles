vim.schedule(function()
  vim.pack.add({ 'https://github.com/norcalli/nvim-colorizer.lua' })

  require('colorizer').setup({
    'css',
    'toml',
    'lua',
    'conf',
  })
end)

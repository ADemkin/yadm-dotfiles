vim.schedule(function()
  vim.pack.add({ 'https://github.com/lukas-reineke/indent-blankline.nvim' })

  require('ibl').setup({
    indent = {
      char = '│',
    },
    scope = { enabled = false },
    exclude = {
      filetypes = {
        'help',
        'startify',
        'dashboard',
        'packer',
        'neogitstatus',
        'NvimTree',
        'Trouble',
      },
    },
  })
end)

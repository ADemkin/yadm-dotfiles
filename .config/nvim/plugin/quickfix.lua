vim.schedule(function()
  vim.pack.add({ 'https://github.com/folke/trouble.nvim' })

  require('trouble').setup({
    modes = {
      symbols = {
        win = {
          type = 'split',
          relative = 'win',
          position = 'right',
          size = 0.25,
        },
      },
    },
  })

  vim.keymap.set('n', '<leader>d', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Fancy diagnostics' })
end)

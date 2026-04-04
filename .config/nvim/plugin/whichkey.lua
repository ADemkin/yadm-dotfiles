vim.schedule(function()
  vim.pack.add({ 'https://github.com/folke/which-key.nvim' })

  require('which-key').setup({
    delay = 500,
    triggers = {
      { '<leader>', mode = { 'n', 'v' } },
      { 'g', mode = { 'n', 'v' } },
    },
  })

  vim.keymap.set('n', '<leader>?', function()
    require('which-key').show({ global = false })
  end, { desc = 'Buffer Local Keymaps (which-key)' })
end)

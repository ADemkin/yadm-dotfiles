vim.schedule(function()
  vim.pack.add({ 'https://github.com/zef/vim-cycle' })

  vim.cmd([[call AddCycleGroup(['markdown', 'txt'], ['[ ]', '[x]'])]])
end)

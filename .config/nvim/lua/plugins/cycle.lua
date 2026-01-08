return {
  'zef/vim-cycle',
  event = 'VeryLazy',
  config = function()
    vim.cmd([[call AddCycleGroup(['markdown', 'txt'], ['[ ]', '[x]'])]])
  end,
}

-- vim-sleuth/surround/repeat: eager; commentary/abolish/dispatch: deferred

vim.pack.add({ 'https://github.com/tpope/vim-sleuth' })
vim.pack.add({ 'https://github.com/tpope/vim-surround' })
vim.pack.add({ 'https://github.com/tpope/vim-repeat' })

vim.schedule(function()
  vim.pack.add({ 'https://github.com/tpope/vim-commentary' })
  vim.pack.add({ 'https://github.com/tpope/vim-abolish' })
  vim.pack.add({ 'https://github.com/tpope/vim-dispatch' })
end)

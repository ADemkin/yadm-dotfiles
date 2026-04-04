vim.g.mw_no_mappings = 1

vim.schedule(function()
  vim.pack.add({
    'https://github.com/inkarkat/vim-ingo-library',
    'https://github.com/idbrii/vim-mark',
  })

  vim.keymap.set('n', '<Leader>m', '<Plug>MarkSet')
  vim.keymap.set('n', '<C-c>', ':nohl<CR>:MarkClear<CR>', { silent = true })
end)

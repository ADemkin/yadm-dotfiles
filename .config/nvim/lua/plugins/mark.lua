return {
  'idbrii/vim-mark',
  command = { 'MarkSet' },
  dependencies = {
    {
      'inkarkat/vim-ingo-library',
    },
  },
  init = function()
    vim.g.mw_no_mappings = 1
  end,
  config = function()
    vim.cmd([[
      nnoremap <Leader>m <Plug>MarkSet
    ]])
    vim.keymap.set('n', '<C-c>', ':nohl<CR>:MarkClear<CR>', { silent = true })
  end,
}

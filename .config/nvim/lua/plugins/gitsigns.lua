-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
  'lewis6991/gitsigns.nvim',
  event = 'BufReadPre',
  config = function()
    require('gitsigns').setup({
      signcolumn = false,
      numhl = true,
      linehl = false,
    })
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', 'tj', ':Gitsigns next_hunk<CR>', opts)
    vim.keymap.set('n', 'tk', ':Gitsigns prev_hunk<CR>', opts)
    vim.keymap.set('n', 'tu', ':Gitsigns reset_hunk<CR>', opts)
  end,
}

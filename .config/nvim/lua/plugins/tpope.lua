return {
  { 'tpope/vim-sleuth' },
  {
    'tpope/vim-fugitive',
    event = 'VeryLazy',
    config = function()
      vim.keymap.set('n', 'ts', ':Git<CR>', { noremap = true, silent = true, desc = 'Git status' })
      vim.keymap.set('n', 'tg', ':Git<CR>', { noremap = true, silent = true, desc = 'Git status' })
    end,
  },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-abolish' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
}

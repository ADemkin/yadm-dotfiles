return {
  'utilyre/barbecue.nvim',
  event = { 'BufReadPost' },
  dependencies = {
    'SmiteshP/nvim-navic',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    exclude_filetypes = { 'gitcommit' },
  },
}

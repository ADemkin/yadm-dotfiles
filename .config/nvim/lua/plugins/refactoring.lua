return {

  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'lewis6991/async.nvim',
    },
    lazy = true,
    opts = {},
    keys = {
      {
        '<leader>r',
        function()
          require('refactoring').select_refactor()
        end,
      },
    },
  },
}

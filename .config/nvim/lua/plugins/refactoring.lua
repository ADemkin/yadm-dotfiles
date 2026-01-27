return {

  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
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

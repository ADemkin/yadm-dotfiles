return {
  'nvim-treesitter/nvim-treesitter-context',
  event = 'VeryLazy',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    --- @param options? TSContext.UserConfig
    require('treesitter-context').setup({
      enable = true,
      max_lines = 2,
    })
  end,
}

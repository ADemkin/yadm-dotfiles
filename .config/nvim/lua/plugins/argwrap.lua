return {
  {
    'FooSoft/vim-argwrap',
    cmd = 'ArgWrap',
    init = function()
      vim.g.argwrap_tail_comma = 1
    end,
  },
  {
    'Wansmer/treesj',
    event = 'VeryLazy',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      use_default_keymaps = false,
      max_join_length = 512,
    },
    keys = {
      {
        '<leader>j',
        function()
          if require('treesj.langs')[vim.bo.filetype] then
            require('treesj').toggle()
          else
            vim.cmd('ArgWrap')
          end
        end,
      },
      {
        '<leader>J',
        function()
          if require('treesj.langs')[vim.bo.filetype] then
            require('treesj').toggle({ split = { recursive = true } })
          else
            vim.cmd('ArgWrap')
          end
        end,
      },
    },
  },
}

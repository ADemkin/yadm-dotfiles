return {
  'nvim-treesitter/nvim-treesitter-textobjects',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('nvim-treesitter.configs').setup({
      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
          keymaps = {
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['ac'] = '@class.outer',
            ['ic'] = { query = '@class.inner', desc = 'Select inner part of a class region' },
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            [']f'] = '@function.outer',
            [']c'] = { query = '@class.outer', desc = 'Next class start' },
          },
          goto_next_end = {
            [']F'] = '@function.outer',
            [']c'] = '@class.outer',
          },
          goto_previous_start = {
            ['[f'] = '@function.outer',
            ['[c'] = '@class.outer',
          },
          goto_previous_end = {
            ['[F'] = '@function.outer',
            ['[c'] = '@class.outer',
          },
        },
      },
    })
  end,
}

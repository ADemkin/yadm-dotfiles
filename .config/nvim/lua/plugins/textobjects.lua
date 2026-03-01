return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    event = 'VeryLazy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim-treesitter.configs').setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              [']f'] = '@function.outer',
              [']c'] = '@class.outer',
              [']a'] = '@parameter.inner',
            },
            goto_next_end = {
              [']F'] = '@function.outer',
              [']C'] = '@class.outer',
              [']A'] = '@parameter.outer',
            },
            goto_previous_start = {
              ['[f'] = '@function.outer',
              ['[c'] = '@class.outer',
              ['[a'] = '@parameter.inner',
            },
            goto_previous_end = {
              ['[F'] = '@function.outer',
              ['[C'] = '@class.outer',
              ['[A'] = '@parameter.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['}a'] = '@parameter.inner',
            },
            swap_previous = {
              ['{a'] = '@parameter.inner',
            },
          },
          lsp_interop = {
            enable = true,
            border = 'single',
            floating_preview_opts = {},
            peek_definition_code = {
              ['gp'] = '@function.outer',
              ['gP'] = '@class.outer',
            },
          },
        },
      })
    end,
  },
  {
    -- supply additional text objects:
    -- * `b` for brackets
    -- * `q` for quotes
    -- * `a` for arguments
    'echasnovski/mini.ai',
    event = 'VeryLazy',
    version = '*',
    opts = {
      custom_textobjects = {
        f = false,
      },
    },
  },
}

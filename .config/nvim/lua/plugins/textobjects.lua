return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    event = 'VeryLazy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true,
        },
      })

      local select = require('nvim-treesitter-textobjects.select')
      local swap = require('nvim-treesitter-textobjects.swap')
      vim.keymap.set({ 'x', 'o' }, 'af', function()
        select.select_textobject('@function.outer')
      end)
      vim.keymap.set({ 'x', 'o' }, 'if', function()
        select.select_textobject('@function.inner')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ac', function()
        select.select_textobject('@class.outer')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ic', function()
        select.select_textobject('@class.inner')
      end)
      vim.keymap.set({ 'x', 'o' }, 'aa', function()
        select.select_textobject('@parameter.outer')
      end)
      vim.keymap.set({ 'x', 'o' }, 'ia', function()
        select.select_textobject('@parameter.inner')
      end)
      vim.keymap.set('n', '}a', function()
        swap.swap_next('@parameter.inner')
      end)
      vim.keymap.set('n', '{a', function()
        swap.swap_previous('@parameter.inner')
      end)
    end,
  },
}


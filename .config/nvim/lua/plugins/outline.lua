return {
  'hedyhli/outline.nvim',
  event = 'VeryLazy',
  config = function()
    vim.keymap.set('n', '<leader>n', '<cmd>Outline<CR>', { desc = 'Toggle Outline' })
    require('outline').setup({
      outline_window = {
        auto_jump = true,
      },
      symbols = {
        icons = {
          Class = { icon = 'class', hl = 'Type' },
          Method = { icon = 'm', hl = 'Function' },
          Constructor = { icon = 'init', hl = 'Special' },
          Enum = { icon = 'Enum', hl = 'Type' },
          Interface = { icon = 'I', hl = 'Type' },
          Function = { icon = 'fn', hl = 'Function' },
          Variable = { icon = 'var', hl = 'Constant' },
          Constant = { icon = 'const', hl = 'Constant' },
          String = { icon = 'str', hl = 'String' },
          Boolean = { icon = 'bool', hl = 'Boolean' },
          Array = { icon = '[]', hl = 'Constant' },
          Object = { icon = 'obj', hl = 'Type' },
          Key = { icon = 'k', hl = 'Type' },
          Null = { icon = 'nil', hl = 'Type' },
          EnumMember = { icon = 'enum', hl = 'Identifier' },
          Struct = { icon = 'struct', hl = 'Structure' },
          Operator = { icon = '+', hl = 'Identifier' },
        },
      },
    })
  end,
}

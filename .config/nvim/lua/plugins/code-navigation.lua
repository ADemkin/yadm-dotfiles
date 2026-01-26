return {
  'hedyhli/outline.nvim',
  lazy = true,
  cmd = { 'Outline', 'OutlineOpen' },
  opts = {
    outline_window = {
      auto_jump = true,
    },
    symbols = {
      icons = {
        Class = { icon = 'C', hl = 'Type' },
        Method = { icon = 'm', hl = 'Function' },
        Constructor = { icon = 'i', hl = 'Special' },
        Enum = { icon = 'E', hl = 'Type' },
        Interface = { icon = 'I', hl = 'Type' },
        Function = { icon = 'f', hl = 'Function' },
        Variable = { icon = 'v', hl = 'Constant' },
        Constant = { icon = 'c', hl = 'Constant' },
        String = { icon = 's', hl = 'String' },
        Boolean = { icon = 'b', hl = 'Boolean' },
        Array = { icon = '[]', hl = 'Constant' },
        Object = { icon = '{}', hl = 'Type' },
        Key = { icon = 'K', hl = 'Type' },
        Null = { icon = '-', hl = 'Type' },
        EnumMember = { icon = 'e', hl = 'Identifier' },
        Struct = { icon = 'S', hl = 'Structure' },
        Operator = { icon = '+', hl = 'Identifier' },
      },
    },
  },
  keys = {
    { '<leader>n', '<cmd>Outline<CR>' },
  },
}

return {
  -- aerial has telescope integration!
  -- Also consider aerial.nvim and oskarrrrrrr/symbols.nvim
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    opts = {
      outline_window = {
        position = 'left',
        width = 15,
        auto_width = {
          enabled = true,
          max_width = 40,
        },
        auto_close = true,
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
  },
  -- {
  --   'oskarrrrrrr/symbols.nvim',
  --   config = function()
  --     local r = require('symbols.recipes')
  --     require('symbols').setup(r.DefaultFilters, r.AsciiSymbols, {
  --       sidebar = {
  --         -- custom settings here
  --         -- e.g. hide_cursor = false
  --       },
  --     })
  --     vim.keymap.set('n', ',s', '<cmd>Symbols<CR>')
  --     vim.keymap.set('n', ',S', '<cmd>SymbolsClose<CR>')
  --   end,
  -- },
}

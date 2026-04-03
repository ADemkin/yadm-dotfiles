return {
  -- aerial has telescope integration!
  -- Also consider aerial.nvim and oskarrrrrrr/symbols.nvim
  {
    'hedyhli/outline.nvim',
    lazy = true,
    cmd = { 'Outline', 'OutlineOpen' },
    opts = {
      symbol_folding = {
        markers = { '', '' },
      },

      outline_window = {
        position = 'left',
        width = 15,
        -- auto_width = {
        --   enabled = true,
        --   max_width = 40,
        -- },
        auto_close = true,
        auto_jump = true,
        winhl = 'Normal:OutlineSidebarBg,NormalNC:OutlineSidebarBg,EndOfBuffer:OutlineSidebarEob,CursorLine:NeoTreeCursorLine,WinSeparator:NeoTreeWinSeparator',
      },
      symbols = {
        icons = {
          File = { icon = '', hl = 'Identifier' },
          Module = { icon = '', hl = 'Include' },
          Namespace = { icon = '', hl = 'Include' },
          Package = { icon = '', hl = 'Include' },
          Class = { icon = '', hl = 'NeoTreeDirectoryName' },
          Method = { icon = '', hl = 'Function' },
          Property = { icon = '', hl = 'Identifier' },
          Field = { icon = '', hl = 'Identifier' },
          Constructor = { icon = '', hl = 'Function' },
          Enum = { icon = '', hl = 'NeoTreeDirectoryName' },
          Interface = { icon = '', hl = 'Function' },
          Function = { icon = '', hl = 'Function' },
          Variable = { icon = '', hl = 'NeoTreeNormal' },
          Constant = { icon = '', hl = 'Constant' },
          String = { icon = '', hl = 'String' },
          Number = { icon = '', hl = 'Number' },
          Boolean = { icon = '', hl = 'Constant' },
          Array = { icon = '', hl = 'Constant' },
          Object = { icon = '', hl = 'Constant' },
          Key = { icon = '', hl = 'Constant' },
          Null = { icon = '', hl = 'DiagnosticError' },
          EnumMember = { icon = '', hl = 'Constant' },
          Struct = { icon = '', hl = 'NeoTreeDirectoryName' },
          Event = { icon = '', hl = 'Type' },
          Operator = { icon = '', hl = 'DiagnosticError' },
          TypeParameter = { icon = '', hl = 'Type' },
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

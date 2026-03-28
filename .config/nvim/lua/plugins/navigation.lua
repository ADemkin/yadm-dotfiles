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
          Class = { icon = 'C', hl = 'NeoTreeDirectoryName' },
          Method = { icon = 'm', hl = 'Function' },
          Constructor = { icon = 'i', hl = 'Function' },
          Enum = { icon = 'E', hl = 'NeoTreeDirectoryName' },
          Interface = { icon = 'I', hl = 'Function' },
          Function = { icon = 'f', hl = 'Function' },
          Variable = { icon = 'v', hl = 'NeoTreeNormal' },
          Constant = { icon = 'c', hl = 'Constant' },
          String = { icon = 's', hl = 'String' },
          Boolean = { icon = 'b', hl = 'Constant' },
          Array = { icon = '[]', hl = 'Constant' },
          Object = { icon = '{}', hl = 'Constant' },
          Key = { icon = 'K', hl = 'Constant' },
          Null = { icon = '-', hl = 'DiagnosticError' },
          EnumMember = { icon = 'e', hl = 'Constant' },
          Struct = { icon = 'S', hl = 'NeoTreeDirectoryName' },
          Operator = { icon = '+', hl = 'DiagnosticError' },
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

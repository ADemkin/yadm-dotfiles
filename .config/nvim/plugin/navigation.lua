vim.schedule(function()
  vim.pack.add({ 'https://github.com/hedyhli/outline.nvim' })

  require('outline').setup({
    symbol_folding = {
      markers = { '', '' },
    },
    outline_window = {
      position = 'left',
      width = 15,
      auto_close = true,
      auto_jump = true,
      winhl = 'Normal:OutlineSidebarBg,NormalNC:OutlineSidebarBg,EndOfBuffer:OutlineSidebarEob,CursorLine:NeoTreeCursorLine,WinSeparator:NeoTreeWinSeparator',
    },
    symbols = {
      icons = {
        File = { icon = '', hl = 'Identifier' },
        Module = { icon = '', hl = 'Include' },
        Namespace = { icon = '', hl = 'Include' },
        Package = { icon = '', hl = 'Include' },
        Class = { icon = '', hl = 'NeoTreeDirectoryName' },
        Method = { icon = '', hl = 'Function' },
        Property = { icon = '', hl = 'Identifier' },
        Field = { icon = '', hl = 'Identifier' },
        Constructor = { icon = '', hl = 'Function' },
        Enum = { icon = '', hl = 'NeoTreeDirectoryName' },
        Interface = { icon = '', hl = 'Function' },
        Function = { icon = '', hl = 'Function' },
        Variable = { icon = '', hl = 'NeoTreeNormal' },
        Constant = { icon = '', hl = 'Constant' },
        String = { icon = '', hl = 'String' },
        Number = { icon = '', hl = 'Number' },
        Boolean = { icon = '', hl = 'Constant' },
        Array = { icon = '', hl = 'Constant' },
        Object = { icon = '', hl = 'Constant' },
        Key = { icon = '', hl = 'Constant' },
        Null = { icon = '', hl = 'DiagnosticError' },
        EnumMember = { icon = '', hl = 'Constant' },
        Struct = { icon = '', hl = 'NeoTreeDirectoryName' },
        Event = { icon = '', hl = 'Type' },
        Operator = { icon = '', hl = 'DiagnosticError' },
        TypeParameter = { icon = '', hl = 'Type' },
      },
    },
  })

  vim.keymap.set('n', '<leader>n', '<cmd>Outline<CR>')
end)

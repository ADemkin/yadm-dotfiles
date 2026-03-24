function dumps(data)
  local raw = vim.fn.json_encode(data)
  ok, _ = pcall(vim.fn.writefile, { raw }, './monokai_scheme.json')
  vim.print(ok)
end
return {
  'loctvl842/monokai-pro.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('monokai-pro').setup({
      background_clear = {
        'float_win',
      },
      disabled_plugins = {
        'nvim-telescope/telescope.nvim', -- allow override to work
      },
      -- TODO: f"" make f orange
      filter = 'classic', -- classic | octagon | pro | machine | ristretto | spectrum
      ---@type fun(scheme: MonokaiPro.Scheme): table<string, vim.api.keyset.highlight>
      override = function(scheme)
        -- dumps(scheme)
        local white = { fg = scheme.base.white }
        local orange = { fg = scheme.base.blue } -- yes, orange is blue
        local aqua = { fg = scheme.base.cyan }
        local green = { fg = scheme.base.green }
        local yellow = { fg = scheme.base.yellow }
        local purple = { fg = scheme.base.magenta }
        local red = { fg = scheme.base.red }
        return {
          -- WinSeparator = { fg = scheme.base.dimmed4 },
          Todo = { bg = 'NONE', fg = scheme.base.blue },
          SpellBad = { fg = 'NONE', sp = scheme.base.red, undercurl = true },
          SpellCap = { link = 'SpellBad' },
          SpellLocal = { link = 'SpellBad' },
          SpellRare = { link = 'SpellBad' },
          MatchParen = {
            underline = false,
            fg = scheme.base.red,
          },
          CursorLineNr = orange,
          Search = { fg = scheme.editor.background, bg = scheme.base.yellow },
          IncSearch = { fg = scheme.editor.background, bg = scheme.base.yellow },
          CurSearch = { fg = scheme.editor.background, bg = scheme.base.blue },
          -- LspReferenceText = { reverse = true },
          -- LspReferenceRead = { reverse = true },
          -- LspReferenceWrite = { reverse = true },  -- объявление
          -- LspReferenceTarget = { reverse = true },  -- word under cursor
          LspReferenceText = { fg = 'NONE' },
          LspReferenceRead = { fg = 'NONE' },
          LspReferenceWrite = { fg = scheme.base.blue },
          DiagnosticUnnecessary = { link = 'Comment' },
          -- LspReferenceText = { bg = scheme.editor.wordHighlightStrongBackground },
          -- LspReferenceRead = { bg = scheme.editor.wordHighlightStrongBackground },
          -- LspReferenceWrite = { bg = scheme.editor.wordHighlightStrongBackground },
          ['@punctuation.bracket'] = white,
          ['@constructor'] = white,
          ['@constant'] = white,
          ['@function.method.call'] = white,
          ['@function.builtin'] = aqua,
          ['@function.call'] = white,
          ['@variable.builtin'] = aqua,
          ['@variable.parameter'] = white,
          ['@module'] = white,
          ['@constant.builtin'] = aqua,
          ['@type'] = white,
          ['@punctuation.special'] = red,
          ['@punctuation.delimiter'] = white,
          ['@string.documentation'] = yellow,
          -- python
          -- EXPERIMENT START -- :: GREEN CLASS
          -- ['@lsp.type.class'] = green,
          -- ['@lsp.type.enum.python'] = green,
          -- EXPERIMENT END --
          ['@lsp.type.decorator.python'] = {},
          ['@lsp.typemod.selfParameter.parameter.python'] = orange,
          ['@lsp.typemod.clsParameter.parameter.python'] = orange,
          ['@lsp.typemod.parameter.parameter.python'] = orange,
          ['@lsp.typemod.class.declaration.python'] = green,
          ['@lsp.typemod.method.declaration.python'] = green,
          -- ['@lsp.type.function.python'] = white,
          ['@lsp.type.function.python'] = {},
          ['@lsp.type.method.python'] = {},
          -- ['@lsp.type.type.python'] = white,
          ['@lsp.type.type.python'] = {},
          -- go
          ['@constant.builtin.go'] = purple,
          -- lua
          ['@comment.documentation.lua'] = white,
          ['@lsp.type.comment.lua'] = {},
          ['@lsp.type.type'] = green,
          -- git
          ['@markup.heading.gitcommit'] = white,
          ['@string.special.path.gitcommit'] = yellow,
          fugitiveSymbolicRef = white,
          fugitiveUntrackedModifier = orange,
          fugitiveStagedModifier = orange,
          fugitiveUnstagedModifier = orange,
          fugitiveHash = aqua,
          -- yaml
          ['@property.yaml'] = white,
          -- Telescope
          TelescopePromptCounter = { fg = scheme.base.dimmed3 },
          TelescopeBorder = { bg = scheme.editor.background, fg = scheme.tab.unfocusedActiveBorder },
          -- markdown render
          RenderMarkdownH1Bg = red,
          RenderMarkdownH2Bg = aqua,
          RenderMarkdownH3Bg = green,
          RenderMarkdownH4Bg = purple,
          RenderMarkdownH5Bg = white,
          RenderMarkdownH6Bg = white,
          -- Outline (matches neotree dark sidebar style)
          OutlineCurrent = { bg = scheme.list.activeSelectionBackground, bold = true },
          OutlineGuides = { fg = scheme.editorIndentGuide.background },
          OutlineFoldMarker = { fg = scheme.sideBar.foreground },
          OutlineDetails = { fg = scheme.base.dimmed3 },
        }
      end,
    })
    vim.cmd.colorscheme('monokai-pro')

    local s = require('monokai-pro').get_scheme()
    vim.api.nvim_set_hl(0, 'pythonDecoratorAt', { fg = s.base.red })
    vim.api.nvim_set_hl(0, 'pythonDecoratorName', { fg = s.base.green })
  end,
}

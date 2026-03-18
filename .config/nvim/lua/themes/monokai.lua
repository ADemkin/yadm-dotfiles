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
      -- TODO: FIX FUCKING SEARCH HIGHLIGHTS!!!
      -- TODO: FIX FUCKING DICTIONARY ERRORS IN RED AND UNDERCURL!
      -- TODO: Fix complement bracket highlight (like in gruvbox?)
      -- TODO: f"" make f orange
      -- TODO: @decorator make @ red
      -- TODO: fix black color in lualine
      -- TODO: fix error suggestion: border and bg
      filter = 'classic', -- classic | octagon | pro | machine | ristretto | spectrum
      ---@field override? fun(scheme: MonokaiPro.Scheme)
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
          WinSeparator = { fg = scheme.base.dimmed4 },
          ['@punctuation.bracket'] = white,
          ['@constructor'] = white,
          ['@constant'] = white,
          ['@function.method.call'] = aqua,
          ['@function.builtin'] = aqua,
          ['@variable.parameter'] = white,
          ['@module'] = white,
          ['@constant.builtin'] = aqua,
          -- ['@type'] = green,
          ['@type'] = white,
          ['@punctuation.special'] = red,
          ['@comment.todo.comment'] = orange,
          -- ['@punctuation.special'] = orange,
          ['@punctuation.delimiter'] = white,
          ['@string.documentation'] = yellow,
          -- python
          ['@lsp.typemod.selfParameter.parameter.python'] = orange,
          ['@lsp.typemod.clsParameter.parameter.python'] = orange,
          ['@lsp.typemod.parameter.parameter.python'] = orange,
          ['@lsp.typemod.class.declaration.python'] = green,
          -- ['@type.python'] = white,
          -- ['@lsp.type.class.python'] = white,
          -- lua
          ['@comment.documentation.lua'] = white,
          -- git
          ['@markup.heading.gitcommit'] = white,
          -- ['@string.special.path.gitcommit'] = { link = 'Comment' },
          ['@string.special.path.gitcommit'] = yellow,
          ['fugitiveSymbolicRef'] = white,
          ['fugitiveUntrackedModifier'] = orange,
          -- yaml
          ['@property.yaml'] = white,
        }
      end,
      ---@field override_scheme? fun(scheme: MonokaiPro.Scheme, palette: MonokaiPro.Palette, colors: MonokaiPro.Colors): MonokaiPro.Scheme
      override_scheme = function(scheme, palette, colors)
        scheme.breadcrumb.foreground = scheme.base.white
        -- scheme.statusBar.background = scheme.base.black
        return scheme
      end,
    })
    vim.cmd.colorscheme('monokai-pro')
    -- local lualine = require('lualine.themes.monokai-pro')
    -- local scheme = monokai.get_scheme()
    -- lualine.
  end,
}

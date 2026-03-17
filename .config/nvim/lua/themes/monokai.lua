return {
  'loctvl842/monokai-pro.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('monokai-pro').setup({
      -- TODO: f"" make f orange
      -- TODO: @decorator make @ red
      filter = 'classic', -- classic | octagon | pro | machine | ristretto | spectrum
      override = function(scheme)
        return {
          ['@punctuation.bracket'] = { fg = scheme.base.white },
          ['@constructor'] = { fg = scheme.base.white },
          ['@constant'] = { fg = scheme.base.white },
          ['@function.method.call'] = { fg = scheme.base.cyan },
          ['@variable.parameter'] = { fg = scheme.base.white },
          ['@type'] = { fg = scheme.base.green },
          ['@lsp.typemod.selfParameter.parameter.python'] = { fg = scheme.base.blue },
          ['@lsp.typemod.clsParameter.parameter.python'] = { fg = scheme.base.blue },
          ['@punctuation.special'] = { fg = scheme.base.blue },
          ['@punctuation.delimiter'] = { fg = scheme.base.white },
          ['@lsp.typemod.parameter.parameter.python'] = { fg = scheme.base.blue },
        }
      end,
      ---@field override_scheme? fun(scheme: MonokaiPro.Scheme, palette: MonokaiPro.Palette, colors: MonokaiPro.Colors): MonokaiPro.Scheme
      override_scheme = function(scheme, palette, colors)
        scheme.breadcrumb.foreground = scheme.base.white
        -- scheme.statusBar.background = scheme.base.black
        return scheme
        -- return {
        --   statusBar = {
        --     background = scheme.base.white,
        --   },
        -- }
      end,
    })
    vim.cmd.colorscheme('monokai-pro')
    -- local lualine = require('lualine.themes.monokai-pro')
    -- local scheme = monokai.get_scheme()
    -- lualine.
  end,
}

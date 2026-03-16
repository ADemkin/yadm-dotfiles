return {
  'loctvl842/monokai-pro.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('monokai-pro').setup({
      -- TODO:
      -- scheme.breadcrumb.foreground = scheme.base.black
      filter = 'classic', -- classic | octagon | pro | machine | ristretto | spectrum
      override = function(scheme)
        return {
          ['@punctuation.bracket'] = { fg = scheme.base.white },
          ['@constructor'] = { fg = scheme.base.white },
          ['@variable.parameter'] = { fg = scheme.base.white },
          ['@type'] = { fg = scheme.base.green },
          -- ['@lsp.typemod.selfParameter.parameter.python'] = { link = '@variable.parameter' },
          -- ['@lsp.typemod.clsParameter.parameter.python'] = { link = '@variable.parameter' },
          ['@lsp.typemod.selfParameter.parameter.python'] = { fg = scheme.base.blue },
          ['@lsp.typemod.clsParameter.parameter.python'] = { fg = scheme.base.blue },
          ['@punctuation.special'] = { fg = scheme.base.blue },
          ['@punctuation.delimiter'] = { fg = scheme.base.white },
        }
      end,
    })
    vim.cmd.colorscheme('monokai-pro')
  end,
}

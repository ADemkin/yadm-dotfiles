return {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1000,
  config = function()
    require('gruvbox').setup({
      overrides = {
        -- Fix diagnostics SignColumn background
        SignColumn = { link = 'Normal' },
        GruvboxRedSign = { link = 'GruvboxRed' },
        GruvboxGreenSign = { link = 'GruvboxGreen' },
        GruvboxYellowSign = { link = 'GruvboxYellow' },
        GruvboxBlueSign = { link = 'GruvboxBlue' },
        GruvboxPurpleSign = { link = 'GruvboxPurple' },
        GruvboxAquaSign = { link = 'GruvboxAqua' },
        GruvboxOrangeSign = { link = 'GruvboxOrange' },
        NeoTreeGitAdded = { link = 'GitGutterAdd' },
        NeoTreeGitConflict = { link = 'GruvboxOragne' },
        NeoTreeGitDeleted = { link = 'GitGutterDelete' },
        NeoTreeGitIgnored = { link = 'NeoTreeDotfile' },
        NeoTreeGitModified = { link = 'GruvboxAqua' },
        NeoTreeGitRenamed = { link = 'NeoTreeGitModified' },
        NeoTreeGitStaged = { link = 'NeoTreeGitAdded' },
        NeoTreeGitUntracked = { link = 'GruvboxOragne' },
        NeoTreeGitUnstaged = { link = 'NeoTreeGitConflict' },
        -- PreProc = { link = 'GruvboxFg0' },
        ['@field'] = { link = 'GruvboxFg0' },
        ['@property'] = { link = 'GruvboxFg0' },
        ['@punctuation.bracket'] = { link = 'GruvboxFg0' },
        ['@punctuation.delimiter'] = { link = 'GruvboxFg0' },
        -- ['@punctuation.special'] = { link = 'GruvboxFg0' },
        -- has conflict with LSP symbols:
        -- ['Function'] = { link = 'GruvboxFg0' },
        -- ['@method.call'] = { link = 'GruvboxFg0' },
        -- ['@function.call'] = { link = 'GruvboxFg0' },
        ['String'] = { link = 'GruvboxYellow' },
        -- ['String'] = { link = 'GruvboxAqua' },
        -- ['String'] = { link = 'GruvboxPurple' },
      },
      palette_overrides = {
        dark0 = '#262722',
        dark1 = '#3a3730',
      },
    })
    vim.cmd.colorscheme('gruvbox')
    require('lualine').setup({
      options = {
        theme = 'gruvbox',
      },
    })
  end,
}

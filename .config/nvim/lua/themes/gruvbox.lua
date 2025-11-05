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

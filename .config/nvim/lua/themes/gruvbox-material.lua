return {
  'sainnhe/gruvbox-material',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme('gruvbox-material')
    require('lualine').setup({
      options = {
        theme = 'gruvbox-material',
      },
    })
  end,
}

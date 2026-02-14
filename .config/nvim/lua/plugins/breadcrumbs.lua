return {
  'nvimdev/lspsaga.nvim',
  event = 'LspAttach',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    require('lspsaga').setup({
      hover = { enable = false },
      diagnostic = { enable = false },
      code_action = { enable = false },
      finder = { enable = false },
      definition = { enable = false },
      rename = { enable = false },
      outline = { enable = false },
      callhierarchy = { enable = false },
      typehierarchy = { enable = false },
      implement = { enable = false },
      beacon = { enable = false },
      floaterm = { enable = false },
      lightbulb = { enable = false },
      symbol_in_winbar = {
        enable = true,
        separator = ' > ',
        hide_keyword = false,
        show_file = true,
        folder_level = 1,
        color_mode = true,
        delay = 200,
      },
      ui = {
        devicon = false,
        foldericon = false,
        title = true,
        use_nerd = true,
      },
    })
  end,
}

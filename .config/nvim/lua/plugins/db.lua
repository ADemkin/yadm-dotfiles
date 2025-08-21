return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    {
      'tpope/vim-dadbod',
      lazy = true,
    },
    {
      'kristijanhusak/vim-dadbod-completion',
      ft = { 'sql', 'plsql' },
      lazy = true,
    },
    'tpope/vim-dotenv',
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.dbs = {
      { name = 'Play', url = 'sqlite3://Users/antondemkin/playground.db' },
    }
    vim.g.db_ui_show_help = 0
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dbui',
      callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
      end,
    })
  end,
}

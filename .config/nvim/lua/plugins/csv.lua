return {
  'hat0uma/csvview.nvim',
  cmd = { 'CsvViewEnable', 'CsvViewDisable', 'CsvViewToggle' },
  ft = { 'csv' },
  init = function()
    vim.api.nvim_create_autocmd('BufWinEnter', {
      desc = 'Auto apply Csv renderer',
      group = vim.api.nvim_create_augroup('CsvViewEnable', { clear = true }),
      pattern = { '*.csv' },
      callback = function()
        vim.cmd('CsvViewEnable')
        vim.opt_local.colorcolumn = ''
      end,
    })
  end,
  ---@module "csvview"
  ---@type CsvView.Options
  opts = {
    parser = { comments = { '#', '//' } },
    view = {
      ---@type CsvView.Options.View.DisplayMode
      display_mode = 'border',
    },
  },
}

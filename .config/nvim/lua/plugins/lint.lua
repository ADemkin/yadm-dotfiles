return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      local lint = require('lint')
      lint.linters_by_ft = {
        python = { 'ruff' },
        sh = { 'shellcheck' },
        yaml = { 'yamllint' },
        markdown = { 'markdownlint' },
        rst = { 'rstcheck' },
        sql = { 'sqlfluff' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        make = { 'checkmake' },
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('NvimLint', { clear = true }),
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
  {
    'rshkarin/mason-nvim-lint',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'mfussenegger/nvim-lint',
    },
    opts = { automatic_installation = true },
  },
}

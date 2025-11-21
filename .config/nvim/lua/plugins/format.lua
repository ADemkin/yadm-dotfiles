return {
  {
    'stevearc/conform.nvim',
    event = 'VeryLazy',
    cmd = { 'ConformInfo' },
    dependencies = {
      { 'williamboman/mason.nvim' },
    },
    opts = {
      notify_on_error = false,
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 2000,
      },
      formatters_by_ft = {
        python = {
          -- 'isort',
          'ruff_organize_imports',
          'ruff_format',
        },
        lua = { 'stylua' },
        sh = { 'shfmt' },
        json = { 'prettierd' },
        -- yaml = { 'prettierd' },
        -- markdown = { 'prettierd' },
        rst = {},
        go = { 'gofumpt', 'goimports', 'golines' },
        dockerfile = {},
        sql = { 'sqlfluff' },
        typescript = { 'prettierd' },
        typescriptreact = { 'prettierd' },
        make = {},
      },
    },
    config = function(_, opts)
      require('conform').setup(opts)
      vim.api.nvim_create_user_command('Fmt', function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end, { range = true })
    end,
  },
  {
    'zapling/mason-conform.nvim',
    event = 'VeryLazy',
    dependencies = {
      'williamboman/mason.nvim',
      'stevearc/conform.nvim',
    },
    opts = { automatic_installation = true },
  },
}

local function get_ruff_monorepo_args()
  local cwd = vim.fn.getcwd()
  local monorepo_match = 'moderation%-detectors'
  if not string.find(cwd, monorepo_match) then
    -- vim.notify('Not a monorepo: ' .. cwd, vim.log.levels.DEBUG)
    return {}
  end
  local monorepo_ruff_candidates = {
    vim.fs.normalize('../moderation-tools/ruff.toml'),
    vim.fs.normalize('./moderation-tools/ruff.toml'),
  }
  for _, candidate in ipairs(monorepo_ruff_candidates) do
    local candidate_path = cwd .. '/' .. candidate
    if vim.fn.filereadable(candidate_path) == 1 then
      -- vim.notify('Using monorepo ruff: ' .. candidate_path, vim.log.levels.DEBUG)
      return { '--config', candidate_path }
    end
  end
  return {}
end

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
      -- format_on_save = {
      --   lsp_fallback = true,
      --   timeout_ms = 2000,
      -- },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = 'fallback' }
      end,
      formatters_by_ft = {
        python = {
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
        ['*'] = { 'trim_whitespace' },
      },
      formatters = {
        -- allow ruff to use custom monorepo config
        ruff_format = {
          append_args = function(self, ctx)
            return get_ruff_monorepo_args()
          end,
        },
        ruff_organize_imports = {
          append_args = function(self, ctx)
            return get_ruff_monorepo_args()
          end,
        },
      },
    },
    config = function(_, opts)
      require('conform').setup(opts)

      vim.api.nvim_create_user_command('Fmt', function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end, { range = true })

      vim.api.nvim_create_user_command('Format', function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ['end'] = { args.line2, end_line:len() },
          }
        end
        require('conform').format({ async = true, lsp_format = 'fallback', range = range })
      end, { range = true })

      vim.api.nvim_create_user_command('FormatDisable', function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = 'Disable autoformat-on-save',
        bang = true,
      })

      vim.api.nvim_create_user_command('FormatEnable', function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = 'Re-enable autoformat-on-save',
      })
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

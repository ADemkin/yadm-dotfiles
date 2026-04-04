vim.schedule(function()
  local function get_ruff_monorepo_args_by_bufnr(bufnr)
    bufnr = bufnr or 0
    local root = vim.fs.root(bufnr, {
      'pyproject.toml',
      'ruff.toml',
      '.git',
    })
    if not root or not root:find('moderation%-detectors') then
      return {}
    end
    local candidates = {
      root .. '/../moderation-tools/ruff.toml',
      root .. '/moderation-tools/ruff.toml',
    }
    for _, path in ipairs(candidates) do
      if vim.uv.fs_stat(path) then
        return { '--config', path }
      end
    end
    return {}
  end

  vim.pack.add({
    'https://github.com/williamboman/mason.nvim',
    'https://github.com/stevearc/conform.nvim',
    'https://github.com/zapling/mason-conform.nvim',
  })

  require('conform').setup({
    notify_on_error = false,
    format_on_save = function(bufnr)
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
      ruff_format = {
        append_args = function(self, ctx)
          return get_ruff_monorepo_args_by_bufnr(ctx.bufnr)
        end,
      },
      ruff_organize_imports = {
        append_args = function(self, ctx)
          return get_ruff_monorepo_args_by_bufnr(ctx.bufnr)
        end,
      },
    },
  })

  require('mason-conform').setup({ automatic_installation = true })

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
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
  end, { desc = 'Disable autoformat-on-save', bang = true })

  vim.api.nvim_create_user_command('FormatEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
  end, { desc = 'Re-enable autoformat-on-save' })
end)

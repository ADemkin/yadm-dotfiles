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
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 2000,
      },
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

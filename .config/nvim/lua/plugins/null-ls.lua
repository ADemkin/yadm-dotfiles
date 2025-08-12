return {
  'nvimtools/none-ls.nvim',
  event = 'VeryLazy',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
    'davidmh/cspell.nvim',
  },
  config = function(_, opts)
    local cspell = require('cspell')
    opts.sources = opts.sources or {}
    table.insert(
      opts.sources,
      cspell.diagnostics.with({
        diagnostics_postprocess = function(diagnostic)
          diagnostic.severity = vim.diagnostic.severity.HINT
        end,
      })
    )
    table.insert(opts.sources, cspell.code_actions)

    local null_ls = require('null-ls')
    local formatting = null_ls.builtins.formatting   -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters
    local code_actions = null_ls.builtins.code_actions

    -- Formatters & linters for mason to install
    require('mason-null-ls').setup({
      ensure_installed = {
        'prettier',  -- ts/js formatter
        'stylua',    -- lua formatter
        'eslint_d',  -- ts/js linter
        'shfmt',     -- Shell formatter
        'checkmake', -- linter for Makefiles
        'gofmt',
        'ruff',
      },
      automatic_installation = true,
    })

    local sources = {
      diagnostics.checkmake,
      formatting.prettier.with({ filetypes = { 'html', 'json', 'yaml', 'markdown' } }),
      formatting.stylua,
      formatting.shfmt.with({ args = { '-i', '4' } }),
      formatting.terraform_fmt,
      formatting.gofmt,
      formatting.goimports,
      formatting.golines,
      diagnostics.cspell,
      code_actions.cspell,
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup({
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client.supports_method('textDocument/formatting') then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })
  end,
}

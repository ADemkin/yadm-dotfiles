vim.schedule(function()
  vim.pack.add({
    'https://github.com/williamboman/mason.nvim', -- shared dep, vim.pack handles duplicates
    'https://github.com/mfussenegger/nvim-lint',
  })

  local lint = require('lint')
  lint.linters_by_ft = {
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

  local function toggle_diagnostics()
    local is_enabled = vim.diagnostic.is_enabled()
    vim.diagnostic.enable(not is_enabled)
  end

  vim.keymap.set('n', 'gtd', toggle_diagnostics)
  vim.keymap.set('n', '<leader>l', toggle_diagnostics)
end)

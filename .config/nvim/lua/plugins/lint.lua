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

      -- vim.diagnostic.enable(false)

      local function toggle_diagnostics()
        local is_enabled = vim.diagnostic.is_enabled()
        vim.diagnostic.enable(not is_enabled)
        vim.notify('Diagnistics ' .. (not is_enabled and '1' or '0'), vim.log.levels.DEBUG)
      end

      -- TODO: this conflicts with after/lsp/basedpyright.lua but working
      -- local function toggle_pyright_type_checking_mode()
      --   local client = vim.lsp.get_clients({ name = 'basedpyright' })[1]
      --   if not client then
      --     vim.notify('BasedPyright LSP is not active', vim.log.levels.WARN)
      --     return
      --   end
      --   local analysis = client.config.settings.basedpyright.analysis
      --   vim.notify('BasedPyright typeCheckingMode: ' .. analysis.typeCheckingMode, vim.log.levels.DEBUG)
      --   if analysis.typeCheckingMode == 'basic' then
      --     analysis.typeCheckingMode = 'recommended'
      --   elseif analysis.typeCheckingMode == 'recommended' then
      --     analysis.typeCheckingMode = 'basic'
      --   end
      --   vim.lsp.stop_client(client.id)
      --   vim.defer_fn(function()
      --     vim.cmd('LspStart basedpyright')
      --     vim.notify('BasedPyright restarted with typeCheckingMode: ' .. analysis.typeCheckingMode)
      --   end, 100)
      -- end
      -- vim.keymap.set('n', '<leader>p', toggle_pyright_type_checking_mode)

      vim.keymap.set('n', 'gtd', toggle_diagnostics)
      vim.keymap.set('n', '<leader>l', toggle_diagnostics)
    end,
  },
}

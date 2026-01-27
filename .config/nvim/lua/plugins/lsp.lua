return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      'mason-org/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- { 'j-hui/fidget.nvim', opts = {} },
      -- 'saghen/blink.cmp',
      -- Allow fucking lua language server to work out of the box:
      {
        'folke/lazydev.nvim',
        ft = 'lua',
        opts = {
          library = {
            { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
          },
        },
      },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf })
          end

          map('gr', vim.lsp.buf.rename)
          map('gd', require('telescope.builtin').lsp_definitions)
          map('gD', function(opts)
            vim.cmd('vsplit')
            require('telescope.builtin').lsp_definitions(opts)
          end)
          map('ga', vim.lsp.buf.code_action, { 'n', 'x' })
          map('gu', require('telescope.builtin').lsp_references)
          map('gi', require('telescope.builtin').lsp_implementations)

          vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- highlight word under cursor
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = event2.buf })
              end,
            })
          end

          -- show diagnostics when hold
          vim.api.nvim_create_autocmd('CursorHold', {
            buffer = event.buf,
            callback = function()
              -- show diagnostics under cursor without stealing focus
              if vim.diagnostic.is_enabled({ bufnr = event.buf }) then
                vim.diagnostic.open_float({
                  scope = 'cursor',
                  focus = false,
                  border = 'single',
                  header = '',
                  prefix = '',
                  source = true,
                })
              end
            end,
          })

          -- toggle virtual text and virtual lines
          vim.keymap.set('n', 'gtv', function()
            local current = vim.diagnostic.config().virtual_text
            if current then
              vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
            else
              vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
            end
          end)

          vim.keymap.set('n', 'gtt', function()
            local filter = { bufnr = event.buf }
            local is_enabled = vim.lsp.inlay_hint.is_enabled(filter)
            vim.lsp.inlay_hint.enable(not is_enabled, filter)
          end)
        end,
      })

      -- HACK to disable all fucking basedpyright diagnostics
      -- idea is taken from here:
      -- https://github.com/m-gail/diagnostic_manipulation.nvim/
      -- local disabled_sources = { 'basedpyright', 'ruff' }
      -- local function filter_diagnostics(diagnostics)
      --   return vim.tbl_filter(function(diagnostic)
      --     for _, src in ipairs(disabled_sources) do
      --       if diagnostic.source == src then
      --         return false
      --       end
      --     end
      --     return true
      --   end, diagnostics)
      -- end
      -- old_set = vim.diagnostic.set
      -- vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
      --   old_set(namespace, bufnr, filter_diagnostics(diagnostics), opts)
      -- end

      -- Diagnostic Config
      ---@param opts vim.diagnostic.Opts
      vim.diagnostic.config({
        -- undercurl all errors
        -- show virtual text only for errors
        severity_sort = true,
        -- underline = { severity = vim.diagnostic.severity.WARN }, -- TODO: add toggle for severity
        virtual_text = {
          severity = vim.diagnostic.severity.ERROR,
          prefix = '●',
          spacing = 2,
          source = true,
          -- source = 'if_many',
        },
        signs = false,
      })

      local ensure_installed = {
        'lua_ls',
        'basedpyright',
        'stylua',
        'yamllint',
        'checkmake',
        'shellcheck',
        'markdownlint',
        'rstcheck',
        'harper-ls', -- spell lint
      }
      require('mason-tool-installer').setup({
        ensure_installed = ensure_installed,
        auto_update = false,
      })

      require('mason-lspconfig').setup({})
    end,
  },
  {
    'Davidyz/inlayhint-filler.nvim',
    event = 'VeryLazy',
    keys = {
      {
        'gti',
        function()
          require('inlayhint-filler').fill()
        end,
        desc = 'Insert the inlay-hint under cursor into the buffer.',
        mode = { 'n' },
      },
    },
  },
}

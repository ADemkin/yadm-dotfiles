return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'saghen/blink.cmp',
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
        -- prefer telescope over vim.lsp.buf.definition to quicker select if multiple results
        map('gd', require('telescope.builtin').lsp_definitions)
        map('gD', function(opts)
          vim.cmd('vsplit')
          require('telescope.builtin').lsp_definitions(opts)
        end)
        map('ga', vim.lsp.buf.code_action, { 'n', 'x' })
        map('gu', vim.lsp.buf.references)
        map('gi', vim.lsp.buf.implementation)

        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

        -- highlight word under cursor
        local client = vim.lsp.get_client_by_id(event.data.client_id)
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
    }
    require('mason-tool-installer').setup({
      ensure_installed = ensure_installed,
      auto_update = false,
    })

    -- local capabilities = require('blink.cmp').get_lsp_capabilities()
    -- allow automatic enable of all installed servers
    require('mason-lspconfig').setup({
      -- ensure_installed = {},
      -- automatic_installation = true,
      -- handlers = {
      --   function(server_name)
      --     local server = { capabilities = capabilities }
      --     vim.lsp.enable(server_name).setup(server)
      --   end,
      -- },
    })
  end,
}

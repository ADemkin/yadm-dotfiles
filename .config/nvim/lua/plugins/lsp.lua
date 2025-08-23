return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufNewFile' },
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

        -- toggle virtual text and virtual lines
        vim.keymap.set('n', 'gvt', function()
          local current = vim.diagnostic.config().virtual_text
          if current then
            vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
          else
            vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
          end
        end)

        if not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }) then
          vim.lsp.inlay_hint.enable()
        end
      end,
    })

    -- Diagnostic Config
    ---@param opts vim.diagnostic.Opts
    vim.diagnostic.config({
      severity_sort = true,
      underline = { severity = vim.diagnostic.severity.ERROR },
      virtual_text = {
        prefix = '●',
        spacing = 2,
      },
      signs = false,
    })

    -- LSP servers and clients are able to communicate to each other what features they support.
    --  By default, Neovim doesn't support everything that is in the LSP specification.
    --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
    --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
              disable = {
                'missing-fields',
              },
            },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed
    --
    -- To check the current status of installed tools and/or manually install
    -- other tools, you can run
    --    :Mason
    --
    -- You can press `g?` for help in this menu.
    --
    -- `mason` had to be setup earlier: to configure its options see the
    -- `dependencies` table for `nvim-lspconfig` above.
    --
    -- You can add other tools here that you want Mason to install
    -- for you, so that they are Undefined global `vim`. available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      'stylua',
    })
    require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

    require('mason-lspconfig').setup({
      ensure_installed = {},
      automatic_installation = true,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    })
  end,
}

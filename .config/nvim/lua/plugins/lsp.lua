return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },
    -- Allows extra capabilities provided by blink.cmp
    'saghen/blink.cmp',
    -- Allow fucking lua language server to work out of the box
    {
      'folke/lazydev.nvim',
      ft = 'lua', -- only load on lua files
      opts = {
        library = {
          -- See the configuration section for more details
          -- Load luvit types when the `vim.uv` word is found
          { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        },
      },
    },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        map('gr', vim.lsp.buf.rename, '[R]ename')
        map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
        -- map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        map('gD', function(opts)
          vim.cmd('vsplit')
          -- vim.lsp.buf.definition(opts)
          require('telescope.builtin').lsp_definitions(opts)
        end, '[G]oto [D]efinition in vsplit')
        map('ga', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('gu', vim.lsp.buf.references, '[G]oto [U]sages')
        map('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

        vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open quickfix diagnostics' })

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
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

        vim.keymap.set('n', 'gvt', function()
          local current = vim.diagnostic.config().virtual_text
          if current then
            vim.diagnostic.config({ virtual_text = false, virtual_lines = true })
          else
            vim.diagnostic.config({ virtual_text = true, virtual_lines = false })
          end
        end, { desc = 'Toggle virtual text/lines' })

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
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

    require('mason-lspconfig').setup({
      ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
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

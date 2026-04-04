vim.schedule(function()

  vim.pack.add({
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
    'https://github.com/Davidyz/inlayhint-filler.nvim',
    'https://github.com/neovim/nvim-lspconfig',
  })

  require('mason').setup()

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf })
      end

      local telescope = require('telescope.builtin')
      map('gr', vim.lsp.buf.rename)
      map('gd', function()
        telescope.lsp_definitions({ show_line = false })
      end)
      map('gD', function()
        vim.cmd('vsplit')
        telescope.lsp_definitions({ show_line = false })
      end)
      map('ga', vim.lsp.buf.code_action, { 'n', 'x' })
      map('gu', function()
        telescope.lsp_references({ show_line = false })
      end)
      map('gi', function()
        telescope.lsp_implementations({ show_line = false })
      end)

      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

      local client = vim.lsp.get_client_by_id(event.data.client_id)

      -- highlight word under cursor
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
        vim.api.nvim_create_autocmd('CursorHold', {
          buffer = event.buf,
          callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
          buffer = event.buf,
          callback = vim.lsp.buf.clear_references,
        })
      end

      -- show diagnostics when hold
      vim.api.nvim_create_autocmd('CursorHold', {
        buffer = event.buf,
        callback = function()
          if vim.diagnostic.is_enabled({ bufnr = event.buf }) then
            vim.diagnostic.open_float({
              scope = 'cursor',
              focus = false,
              border = 'single',
              header = '',
              prefix = '',
              source = 'if_many',
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

      local filter = { bufnr = event.buf }
      vim.keymap.set('n', 'gtt', function()
        local is_enabled = vim.lsp.inlay_hint.is_enabled(filter)
        vim.lsp.inlay_hint.enable(not is_enabled, filter)
      end)
    end,
  })

  vim.diagnostic.config({
    severity_sort = true,
    virtual_text = {
      severity = vim.diagnostic.severity.ERROR,
      prefix = '●',
      spacing = 2,
      source = 'if_many',
    },
    signs = false,
  })

  local ensure_installed = {
    'lua_ls',
    'basedpyright',
    'stylua',
    'yamllint',
    'checkmake',
    'markdownlint',
    'rstcheck',
  }
  require('mason-tool-installer').setup({
    ensure_installed = ensure_installed,
    auto_update = false,
  })

  require('mason-lspconfig').setup({})

  -- inlayhint-filler
  vim.keymap.set('n', 'gti', function()
    require('inlayhint-filler').fill()
  end, { desc = 'Insert the inlay-hint under cursor into the buffer.' })
end)

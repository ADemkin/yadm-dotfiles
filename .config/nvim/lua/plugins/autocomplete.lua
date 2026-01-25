vim.g.blink_enabled = true

return {
  'saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  version = '1.*',
  dependencies = {
    -- Snippet Engine
    -- {
    --   'L3MON4D3/LuaSnip',
    --   version = '2.*',
    --   build = 'make install_jsregexp',
    --   dependencies = {
    --     -- `friendly-snippets` contains a variety of premade snippets.
    --     --    See the README about individual language/framework/plugin snippets:
    --     --    https://github.com/rafamadriz/friendly-snippets
    --     -- {
    --     --   'rafamadriz/friendly-snippets',
    --     --   config = function()
    --     --     require('luasnip.loaders.from_vscode').lazy_load()
    --     --   end,
    --     -- },
    --   },
    --   opts = {},
    -- },
    -- 'giuxtaposition/blink-cmp-copilot',
    'folke/lazydev.nvim', -- required as a provider
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    enabled = function()
      return vim.g.blink_enabled
    end,
    keymap = {
      preset = 'default',
      ['<CR>'] = { 'select_and_accept', 'fallback' }, -- conflict with abbr
      ['<tab>'] = { 'select_and_accept', 'fallback' },
      ['<C-n>'] = { 'show', 'select_next' },
    },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      ghost_text = { enabled = false },
    },
    sources = {
      default = {
        'lsp',
        'buffer',
        'path',
        -- 'snippets',
        'lazydev',
        -- 'copilot',
      },
      providers = {
        lazydev = {
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
        -- copilot = {
        --   name = 'copilot',
        --   module = 'blink-cmp-copilot',
        --   score_offset = 100,
        --   async = true,
        -- },
        buffer = {
          module = 'blink.cmp.sources.buffer',
          score_offset = -100,
        },
      },
    },
    -- snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
    cmdline = {
      keymap = {
        -- Do not remap my readline cmdline keys
        preset = 'none',
        -- ['<Tab>'] = { 'show', 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'show', 'select_next', 'fallback' },
        ['<enter>'] = { 'select_and_accept', 'fallback' },
        ['<tab>'] = { 'show', 'select_and_accept', 'fallback' },
      },
    },
  },
  config = function(_, opts)
    -- hack to deduplicate completion items
    -- https://github.com/saghen/blink.cmp/issues/1222
    local priority = { 'lsp', 'buffer', 'path', 'lazydev' }
    local original = require('blink.cmp.completion.list').show
    ---@diagnostic disable-next-line: duplicate-set-field
    require('blink.cmp.completion.list').show = function(ctx, items_by_source)
      local seen = {}
      local function filter(item)
        if seen[item.label] then
          return false
        end
        seen[item.label] = true
        return true
      end
      for id in vim.iter(priority) do
        items_by_source[id] = items_by_source[id] and vim.iter(items_by_source[id]):filter(filter):totable()
      end
      return original(ctx, items_by_source)
    end
    require('blink.cmp').setup(opts)
  end,
}

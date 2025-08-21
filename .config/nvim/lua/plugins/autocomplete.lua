return {
  'saghen/blink.cmp',
  event = { 'InsertEnter', 'CmdlineEnter' },
  version = '1.*',
  dependencies = {
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = 'make install_jsregexp',
      dependencies = {
        -- `friendly-snippets` contains a variety of premade snippets.
        --    See the README about individual language/framework/plugin snippets:
        --    https://github.com/rafamadriz/friendly-snippets
        -- {
        --   'rafamadriz/friendly-snippets',
        --   config = function()
        --     require('luasnip.loaders.from_vscode').lazy_load()
        --   end,
        -- },
      },
      opts = {},
    },
    'giuxtaposition/blink-cmp-copilot',
    'folke/lazydev.nvim', -- required as a provider
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      -- not yet decided which one is better
      ['<enter>'] = { 'select_and_accept', 'fallback' },
      ['<tab>'] = { 'select_and_accept', 'fallback' },
      ['<C-n>'] = { 'show', 'select_next' },
    },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 3000 },
      ghost_text = { enabled = true },
    },
    sources = {
      default = { 'lsp', 'buffer', 'path', 'snippets', 'lazydev', 'copilot' },
      providers = {
        lazydev = {
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
        copilot = {
          name = 'copilot',
          module = 'blink-cmp-copilot',
          score_offset = 100,
          async = true,
        },
      },
    },
    snippets = { preset = 'luasnip' },
    fuzzy = { implementation = 'lua' },

    -- Shows a signature help window while you type arguments for a function
    signature = { enabled = true },
    cmdline = {
      keymap = {
        -- Do not remap my readline cmdline keys
        preset = 'none',
        ['<Tab>'] = { 'show', 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
      },
    },
  },
}

vim.g.blink_enabled = true

vim.schedule(function()
  vim.pack.add({
    'https://github.com/folke/lazydev.nvim', -- required as blink provider + lua lsp
    'https://github.com/saghen/blink.cmp',
  })

  -- lazydev setup (ft=lua, but we load eagerly so setup applies)
  require('lazydev').setup({
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  })

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

  require('blink.cmp').setup({
    enabled = function()
      return vim.g.blink_enabled
    end,
    keymap = {
      preset = 'default',
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
        'lazydev',
      },
      providers = {
        lazydev = {
          module = 'lazydev.integrations.blink',
          score_offset = 100,
        },
        buffer = {
          module = 'blink.cmp.sources.buffer',
          score_offset = -100,
        },
      },
    },
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true },
    cmdline = {
      keymap = {
        preset = 'none',
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'show', 'select_next', 'fallback' },
        ['<enter>'] = { 'select_and_accept', 'fallback' },
        ['<tab>'] = { 'show', 'select_and_accept', 'fallback' },
      },
    },
  })
end)

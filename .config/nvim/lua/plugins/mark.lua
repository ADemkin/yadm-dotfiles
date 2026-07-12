return {
  'idbrii/vim-mark',
  command = { 'MarkSet' },
  dependencies = {
    {
      'inkarkat/vim-ingo-library',
    },
  },
  init = function()
    vim.g.mw_no_mappings = 1
    -- Pull colors from monokai-pro at runtime
    local p = require('monokai-pro').get_palette('classic')
    local c = require('monokai-pro').get_colors()

    vim.g.mwPalettes = {
      monokai = {
        { guibg = p.accent5, guifg = p.background }, -- cyan
        { guibg = p.accent4, guifg = p.background }, -- green
        { guibg = p.accent3, guifg = p.background }, -- yellow
        { guibg = p.accent1, guifg = p.background }, -- red
        { guibg = p.accent6, guifg = p.background }, -- purple
        { guibg = p.accent2, guifg = p.background }, -- orange
        { guibg = c.blend(p.accent5, 0.7), guifg = p.background }, -- cyan
        { guibg = c.blend(p.accent4, 0.7), guifg = p.background }, -- green
        { guibg = c.blend(p.accent3, 0.7), guifg = p.background }, -- yellow
        { guibg = c.blend(p.accent1, 0.7), guifg = p.background }, -- red
        { guibg = c.blend(p.accent6, 0.7), guifg = p.background }, -- purple
        { guibg = c.blend(p.accent2, 0.7), guifg = p.background }, -- orange
        { guibg = c.blend(p.accent5, 0.5), guifg = p.text }, -- cyan
        { guibg = c.blend(p.accent4, 0.5), guifg = p.text }, -- green
        { guibg = c.blend(p.accent3, 0.5), guifg = p.text }, -- yellow
        { guibg = c.blend(p.accent1, 0.5), guifg = p.text }, -- red
        { guibg = c.blend(p.accent6, 0.5), guifg = p.text }, -- purple
        { guibg = c.blend(p.accent2, 0.5), guifg = p.text }, -- orange
      },
    }
    vim.g.mwDefaultHighlightingPalette = 'monokai'
  end,
  config = function()
    vim.keymap.set('n', '<Leader>m', '<Plug>MarkSet')
    vim.keymap.set('n', '<C-c>', ':nohl<CR>:MarkClear<CR>', { silent = true })
  end,
}

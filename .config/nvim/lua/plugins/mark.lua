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
  end,
  config = function()
    vim.cmd([[
      nnoremap <Leader>m <Plug>MarkSet
      highlight MarkWord0 guibg=#fabd2f guifg=#282828 ctermbg=214 ctermfg=235
      highlight MarkWord1 guibg=#d3869b guifg=#282828 ctermbg=175 ctermfg=235
      highlight MarkWord2 guibg=#8ec07c guifg=#282828 ctermbg=108 ctermfg=235
      highlight MarkWord3 guibg=#fe8019 guifg=#282828 ctermbg=208 ctermfg=235
      highlight MarkWord4 guibg=#83a598 guifg=#282828 ctermbg=109 ctermfg=235
      highlight MarkWord5 guibg=#b8bb26 guifg=#282828 ctermbg=142 ctermfg=235
      highlight MarkWord6 guibg=#fb4934 guifg=#282828 ctermbg=167 ctermfg=235
      highlight MarkWord7 guibg=#cc241d guifg=#ebdbb2 ctermbg=124 ctermfg=223
      highlight MarkWord8 guibg=#d65d0e guifg=#ebdbb2 ctermbg=130 ctermfg=223
      highlight MarkWord9 guibg=#b16286 guifg=#ebdbb2 ctermbg=175 ctermfg=223
      highlight MarkWord10 guibg=#458588 guifg=#ebdbb2 ctermbg=66 ctermfg=223
      highlight MarkWord11 guibg=#98971a guifg=#ebdbb2 ctermbg=142 ctermfg=223
      highlight MarkWord12 guibg=#d79921 guifg=#ebdbb2 ctermbg=214 ctermfg=223
      highlight MarkWord13 guibg=#b8bb26 guifg=#ebdbb2 ctermbg=142 ctermfg=223
      highlight MarkWord14 guibg=#9d0006 guifg=#ebdbb2 ctermbg=167 ctermfg=223
      highlight MarkWord15 guibg=#076678 guifg=#ebdbb2 ctermbg=66 ctermfg=223
      highlight MarkWord16 guibg=#79740e guifg=#ebdbb2 ctermbg=142 ctermfg=223
      highlight MarkWord17 guibg=#b16286 guifg=#ebdbb2 ctermbg=175 ctermfg=223
      highlight MarkWord18 guibg=#d65d0e guifg=#ebdbb2 ctermbg=130 ctermfg=223
      highlight MarkWord19 guibg=#458588 guifg=#ebdbb2 ctermbg=66 ctermfg=223
      let g:mwDefaultHighlightingNum = 19
    ]])
    vim.keymap.set('n', '<C-c>', ':nohl<CR>:MarkClear<CR>', { silent = true })
  end,
}

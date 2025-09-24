return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/neotest-python',
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('neotest').setup({
      summary = {
        mappings = {
          expand = 'l',
        },
      },
      icons = {
        expanded = '┐',
        final_child_prefix = '└',
      },
      adapters = {
        require('neotest-python'),
      },
      highlights = {
        adapter_name = 'Title',
        border = 'FloatBorder',
        dir = 'Directory',
        expand_marker = 'Comment',
        failed = 'DiagnosticError',
        file = 'GruvboxFg1',
        focused = 'Special',
        indent = 'Comment',
        marked = 'Special',
        namespace = 'Title',
        passed = 'DiagnosticOk',
        running = 'DiagnosticWarn',
        select_win = 'Title',
        skipped = 'DiagnosticHint',
        target = 'Type',
        test = 'GruvboxFg1',
        unknown = 'DiagnosticInfo',
        watching = 'Structure',
      },
    })
    -- TODO: add keymap to run single test
    -- TODO: add keymap to toggle test overlay
    -- TODO: add keymap to skip test?
    vim.keymap.set('n', '<leader>ts', function()
      require('neotest').summary.toggle()
    end)
    -- TODO: this does not show failed test output
    vim.keymap.set('n', '<leader>to', function()
      require('neotest').output_panel.toggle()
    end)
  end,
}

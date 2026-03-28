vim.api.nvim_create_autocmd('DirChanged', {
  desc = 'Reload neotest',
  pattern = '*',
  callback = function()
    require('neotest').output_panel.close()
    require('neotest').summary.close()
    require('lazy').reload({ plugins = {
      'neotest',
      'neotest-python',
      'neotest-go',
    } })
  end,
})

return {
  'nvim-neotest/neotest',
  commands = { 'Neotest' },
  dependencies = {
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-go',
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'neotest-summary',
      callback = function()
        vim.wo.winhighlight = 'Normal:NeotestSummaryBg,NormalNC:NeotestSummaryBg,EndOfBuffer:NeotestSummaryBg,WinSeparator:NeoTreeWinSeparator'
      end,
    })

    require('neotest').setup({
      summary = {
        mappings = {
          expand = 'l',
        },
      },
      icons = {
        child_indent = ' ',
        child_prefix = '',
        collapsed = '',
        expanded = '',
        final_child_indent = ' ',
        final_child_prefix = '',
        non_collapsible = '',
        running_animated = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
      },
      adapters = {
        require('neotest-python'),
        require('neotest-go')({
          experimental = {
            test_table = true,
          },
          args = { '-count=1', '-timeout=60s' },
        }),
      },
      highlights = {
        adapter_name = 'NeoTreeRootName',
        border = 'NeoTreeWinSeparator',
        dir = 'NeoTreeRootName',
        expand_marker = 'NeoTreeIndentMarker',
        failed = 'DiagnosticError',
        file = 'NeoTreeRootName',
        focused = 'NeoTreeCursorLine',
        indent = 'NeoTreeIndentMarker',
        marked = 'NeoTreeCursorLine',
        namespace = 'NeoTreeDirectoryName',
        passed = 'DiagnosticOk',
        running = 'DiagnosticWarn',
        select_win = 'NeoTreeRootName',
        skipped = 'DiagnosticHint',
        target = 'NeoTreeDirectoryIcon',
        test = 'NeoTreeNormal',
        unknown = 'DiagnosticInfo',
        watching = 'DiagnosticWarn',
      },
      -- quickfix = { open = true },
    })
  end,
  keys = {
    {
      'tt',
      function()
        require('neotest').summary.toggle()
      end,
      desc = 'Toggle test summary',
    },
    {
      'to',
      function()
        require('neotest').output_panel.toggle()
      end,
      desc = 'Toggle output panel',
    },
    {
      'tp',
      function()
        require('neotest').output.open({ enter = true })
      end,
      desc = 'Open test output',
    },
    {
      'tw',
      function()
        require('neotest').watch.toggle()
      end,
      desc = 'Toggle test watching',
    },
    {
      'tr',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run nearest test',
    },
    {
      'tm',
      function()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
      desc = 'Run tests in file',
    },
    {
      'tl',
      function()
        require('neotest').run.run_last()
      end,
      desc = 'Run last test',
    },
    {
      'ta',
      function()
        require('neotest').run.run(vim.fn.getcwd())
      end,
      desc = 'Run all tests',
    },
    {
      'ts',
      function()
        require('neotest').run.stop()
      end,
      desc = 'Stop test run',
    },
    {
      '[t',
      function()
        require('neotest').jump.prev({ status = 'failed' })
      end,
      desc = 'Jump to previous failed test',
    },
    {
      ']t',
      function()
        require('neotest').jump.next({ status = 'failed' })
      end,
      desc = 'Jump to next failed test',
    },
  },
}

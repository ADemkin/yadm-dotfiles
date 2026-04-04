vim.schedule(function()
  vim.pack.add({
    'https://github.com/nvim-neotest/nvim-nio',
    'https://github.com/antoinemadec/FixCursorHold.nvim',
    'https://github.com/nvim-neotest/neotest-python',
    'https://github.com/nvim-neotest/neotest-go',
    'https://github.com/nvim-neotest/neotest',
  })

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
  })

  -- Reload neotest on directory change
  vim.api.nvim_create_autocmd('DirChanged', {
    desc = 'Reload neotest',
    pattern = '*',
    callback = function()
      require('neotest').output_panel.close()
      require('neotest').summary.close()
      -- Without lazy.nvim's reload, just reset state by closing panels
      -- For a full reload, restart Neovim after switching projects
    end,
  })

  vim.keymap.set('n', 'tt', function() require('neotest').summary.toggle() end, { desc = 'Toggle test summary' })
  vim.keymap.set('n', 'tp', function() require('neotest').output.open({ enter = true }) end, { desc = 'Open test output' })
  vim.keymap.set('n', 'tw', function() require('neotest').watch.toggle() end, { desc = 'Toggle test watching' })
  vim.keymap.set('n', 'tr', function() require('neotest').run.run() end, { desc = 'Run nearest test' })
  vim.keymap.set('n', 'tm', function() require('neotest').run.run(vim.fn.expand('%')) end, { desc = 'Run tests in file' })
  vim.keymap.set('n', 'tl', function() require('neotest').run.run_last() end, { desc = 'Run last test' })
  vim.keymap.set('n', 'ta', function() require('neotest').run.run(vim.fn.getcwd()) end, { desc = 'Run all tests' })
  vim.keymap.set('n', 'ts', function() require('neotest').run.stop() end, { desc = 'Stop test run' })
  vim.keymap.set('n', '[t', function() require('neotest').jump.prev({ status = 'failed' }) end, { desc = 'Jump to previous failed test' })
  vim.keymap.set('n', ']t', function() require('neotest').jump.next({ status = 'failed' }) end, { desc = 'Jump to next failed test' })
end)

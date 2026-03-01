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
        final_child_indent = '',
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
      -- quickfix = { open = true },
    })
  end,
  keys = {
    {
      '<leader>tt',
      function()
        require('neotest').summary.toggle()
      end,
    },
    {
      '<leader>to',
      function()
        require('neotest').output_panel.toggle()
      end,
    },
    {
      '<leader>tp',
      function()
        require('neotest').output.open()
      end,
    },
    {
      '<leader>tr',
      function()
        require('neotest').run.run()
      end,
    },
    {
      '<leader>tm',
      function()
        require('neotest').run.run(vim.fn.expand('%'))
      end,
    },
    {
      '<leader>tl',
      function()
        require('neotest').run.run_last()
      end,
    },
    {
      '<leader>ta',
      function()
        require('neotest').run.run(vim.fn.getcwd())
      end,
    },
    {
      '<leader>ts',
      function()
        require('neotest').run.stop()
      end,
    },
    {
      '[t',
      function()
        require('neotest').jump.prev({ status = 'failed' })
      end,
    },
    {
      ']t',
      function()
        require('neotest').jump.next({ status = 'failed' })
      end,
    },
  },
}

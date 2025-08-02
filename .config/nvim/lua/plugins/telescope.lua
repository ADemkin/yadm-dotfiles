return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable('make') == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' }, -- dropdown menu
    -- { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    'davvid/telescope-git-grep.nvim',
  },
  config = function()
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    -- horizontal_fused layout strategy
    local layout_strategies = require('telescope.pickers.layout_strategies')
    layout_strategies.horizontal_fused = function(picker, max_columns, max_lines, layout_config)
      local layout = layout_strategies.horizontal(picker, max_columns, max_lines, layout_config)
      layout.prompt.title = ''
      layout.results.title = ''
      layout.results.height = layout.results.height + 1
      layout.results.borderchars = { '─', '│', '─', '│', '┌', '┬', '┤', '├' }
      layout.prompt.borderchars = { '─', '│', '─', '│', '┌', '┐', '┴', '└' }
      if layout.preview then
        layout.preview.title = ''
        layout.preview.borderchars = { '─', '│', '─', ' ', '─', '┐', '┘', '─' }
      end
      return layout
    end

    require('telescope').setup({
      defaults = {
        layout_strategy = 'horizontal_fused',
        mappings = {
          i = {
            -- implement readline mappings
            ['<C-a>'] = { '<home>', type = 'command' },
            ['<C-e>'] = { '<end>', type = 'command' },
            ['<M-b>'] = function()
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-Left>', true, false, true), 'n')
            end,
            ['<M-f>'] = function()
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-Right>', true, false, true), 'n')
            end,
            ['<A-BS>'] = function(prompt_bufnr)
              local picker = action_state.get_current_picker(prompt_bufnr)
              picker:set_prompt(picker:_get_prompt():gsub('%s*[%w%p]+%s*$', ''))
            end,
            ['<C-c>'] = actions.close,
            ['<esc>'] = actions.close,
            ['<C-f>'] = require('telescope.actions').delete_buffer,
          },
        },
      },
      pickers = {
        find_files = {
          file_ignore_patterns = { 'node_modules', '.git', '.venv' },
          hidden = true,
        },
      },
      live_grep = {
        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
        additional_args = function(_)
          return { '--hidden' }
        end,
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'git_grep')

    -- See `:help telescope.builtin`
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = '[F]iles' })
    vim.keymap.set('n', '<leader>ff', builtin.resume, { desc = 'Continue last fuzzy search' })
    vim.keymap.set('n', '<leader>ft', builtin.builtin, { desc = '[F]ind [T]elescope builtin' })
    vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = '[F]ind current [W]ord' })
    vim.keymap.set('n', '<leader>fg', function()
      require('git_grep').grep()
    end, { desc = '[F]ind [G]it grep' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]ind [R]ecent files' })
    vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = '[B]uffers' })
    vim.keymap.set('n', '<leader>;', builtin.commands, { desc = 'Commands' })
  end,
}

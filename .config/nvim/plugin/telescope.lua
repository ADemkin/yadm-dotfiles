-- PackChanged hook must be outside vim.schedule to fire on install/update
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    if ev.data.spec.name == 'telescope-fzf-native.nvim' and ev.data.kind ~= 'delete' then
      if vim.fn.executable('make') == 1 then
        vim.fn.system({ 'make', '-C', ev.data.path })
      end
    end
  end,
})

vim.schedule(function()
  vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
    'https://github.com/nvim-telescope/telescope-ui-select.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/SalOrak/whaler',
    'https://github.com/jmacadie/telescope-hierarchy.nvim',
    'https://github.com/debugloop/telescope-undo.nvim',
    'https://github.com/d4wns-l1ght/telescope-messages.nvim',
    'https://github.com/nvim-telescope/telescope.nvim',
  })

  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
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

  layout_strategies.center_fused = function(picker, max_columns, max_lines, layout_config)
    local layout = layout_strategies.center(picker, max_columns, max_lines, layout_config)
    layout.results.height = layout.results.height + 1
    layout.results.borderchars = { '─', '│', '─', '│', '├', '┤', '┘', '└' }
    layout.prompt.borderchars = { '─', '│', '─', '│', '┌', '┐', '┴', '└' }
    return layout
  end

  require('telescope').setup({
    defaults = {
      preview = { treesitter = false },
      layout_strategy = 'horizontal_fused',
      mappings = {
        i = {
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
          ['<C-d>'] = require('telescope.actions').delete_buffer,
        },
      },
    },
    pickers = {
      oldfiles = {
        cwd_only = true,
      },
      find_files = {
        file_ignore_patterns = { 'node_modules', '.git', '.venv', 'venv', '.DS_Store' },
        hidden = true,
      },
    },
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown(),
      },
      whaler = {
        directories = {
          { path = '~/code/', alias = 'code' },
          { path = '~/code/moderation-detectors/', alias = 'md' },
          { path = '~/.config/', alias = 'config' },
        },
        auto_file_explorer = false,
        telescope_opts = {
          layout_config = {
            height = 0.8,
            width = 0.8,
          },
          layout_strategy = 'center_fused',
          prompt_prefix = ' ',
          selection_caret = ' ',
          entry_prefix = ' ',
          results_title = '',
          prompt_title = '',
        },
      },
      hierarchy = {
        layout_strategy = 'horizontal_fused',
      },
    },
  })

  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')
  pcall(require('telescope').load_extension, 'whaler')
  pcall(require('telescope').load_extension, 'hierarchy')
  pcall(require('telescope').load_extension, 'undo')
  pcall(require('telescope').load_extension, 'messages')

  -- Multigrep: search pattern + glob from same prompt
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local make_entry = require('telescope.make_entry')
  local config = require('telescope.config').values

  local multigrep = function(opts)
    opts = opts or {}
    opts.cwd = opts.cwd or vim.uv.cwd()
    local finder = finders.new_async_job({
      command_generator = function(prompt)
        if not prompt or prompt == '' then
          return nil
        end
        local pieces = vim.split(prompt, '  ')
        local command = { 'rg' }
        if pieces[1] then
          table.insert(command, '--regexp')
          table.insert(command, pieces[1])
        end
        if pieces[2] then
          table.insert(command, '--glob')
          table.insert(command, pieces[2])
        end
        return vim.tbl_flatten({
          command,
          {
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
          },
        })
      end,
      entry_maker = make_entry.gen_from_vimgrep(opts),
      cwd = opts.cwd,
    })
    pickers
      .new(opts, {
        debounce = 100,
        prompt_title = 'Multigrep',
        finder = finder,
        previewer = config.grep_previewer(opts),
        sorter = require('telescope.sorters').empty(),
      })
      :find()
  end

  vim.api.nvim_create_user_command('Grep', multigrep, { desc = 'Grep with glob' })

  local builtin = require('telescope.builtin')
  local telescope = require('telescope')

  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
  vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
  vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
  vim.keymap.set('n', '<leader>fc', builtin.resume, { desc = 'Continue last fuzzy search' })
  vim.keymap.set('n', '<leader>ft', builtin.builtin, { desc = '[F]ind [T]elescope builtin' })
  vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols)
  vim.keymap.set('n', '<leader>fg', multigrep, { desc = '[F]ind words and [G]lob' })
  vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = '[F]ind [R]ecent files' })
  vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = '[B]uffers' })
  vim.keymap.set('n', '<leader>f;', builtin.commands, { desc = 'Commands' })
  vim.keymap.set('n', '<leader>fp', telescope.extensions.whaler.whaler, { desc = '[P]roject switch' })
  vim.keymap.set('n', '<leader>fh', telescope.extensions.hierarchy.outgoing_calls, { desc = 'call stack [h]ierarchy' })
  vim.keymap.set('n', '<leader>fH', telescope.extensions.hierarchy.incoming_calls, { desc = 'caller stack [h]ierarchy' })
  vim.keymap.set('n', '<leader>fu', telescope.extensions.undo.undo, { desc = '[U]ndo tree' })
  vim.keymap.set('n', '<leader>fm', telescope.extensions.messages.messages, { desc = '[M]essages' })

  -- spell suggest via telescope
  local function spell_suggest_telescope()
    local word = vim.fn.expand('<cword>')
    local suggestions = vim.fn.spellsuggest(word, 50)
    if vim.tbl_isempty(suggestions) then
      return
    end
    pickers
      .new({}, {
        finder = finders.new_table({ results = suggestions }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, map)
          actions.select_default:replace(function(bufnr)
            local entry = action_state.get_selected_entry()
            actions.close(bufnr)
            vim.cmd('normal! ciw' .. entry[1])
          end)
          return true
        end,
      })
      :find()
  end
  vim.keymap.set('n', 'z=', spell_suggest_telescope, { silent = true })

  vim.api.nvim_create_autocmd('User', {
    pattern = 'WhalerPostSwitch',
    callback = function(event)
      local cwd = event.data.path
      local name = vim.fn.fnamemodify(cwd, ':t')
      vim.system({ 'tmux', 'rename-window', name }, { detach = true })
      vim.cmd('Neotree close')
      vim.cmd('bdelete')
      vim.cmd('Alpha')
    end,
  })
end)

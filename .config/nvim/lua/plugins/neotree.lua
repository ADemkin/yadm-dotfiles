return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup({
      close_if_last_window = true,
      use_popups_for_input = false, -- use vim's comman line for inputs
      popup_border_style = 'single',
      enable_git_status = true,
      git_status_async = true,
      enable_diagnostics = false,
      enable_modified_markers = true,
      open_files_do_not_replace_types = { 'terminal', 'trouble', 'qf' },
      sort_case_insensitive = false,
      sort_function = nil,
      default_component_configs = {
        container = {
          enable_character_fade = true,
        },
        indent = {
          indent_size = 2,
          padding = 0,
          -- indent guides
          with_markers = true,
          indent_marker = '│',
          last_indent_marker = '└',
          highlight = 'NeoTreeIndentMarker',
          -- expander config, needed for nesting files
          with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
        modified = {
          highlight = 'NeoTreeModified',
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
        },
        git_status = {
          symbols = {
            added = '', -- highlight only
            modified = '', -- highlight only
          },
        },

        -- If you don't want to use these columns, you can set `enabled = false` for each of them individually
        file_size = {
          enabled = true,
          required_width = 64, -- min width of window required to show this column
        },
        type = {
          enabled = true,
          required_width = 122, -- min width of window required to show this column
        },
        last_modified = {
          enabled = true,
          required_width = 88, -- min width of window required to show this column
        },
        created = {
          enabled = true,
          required_width = 110, -- min width of window required to show this column
        },
        symlink_target = {
          enabled = false,
        },
      },
      commands = {},
      window = {
        position = 'left',
        width = 30,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          -- ['<cr>'] = 'open',
          ['l'] = 'open',
          ['<esc>'] = 'cancel',
          ['p'] = { 'toggle_preview', config = { use_float = true } },
          ['S'] = 'open_split',
          ['s'] = 'open_vsplit',
          -- ['t'] = 'open_tabnew',
          ['w'] = 'noop',
          ['h'] = 'close_node',
          ['X'] = 'close_all_nodes',
          ['a'] = {
            'add',
            config = {
              show_path = 'relative',
            },
          },
          ['A'] = {
            'add_directory',
            config = {
              show_path = 'relative',
            },
          },
          ['d'] = 'delete',
          ['r'] = 'rename',
          ['c'] = {
            'copy',
            config = {
              show_path = 'relative',
            },
          },
          ['m'] = {
            'move',
            config = {
              show_path = 'relative',
            },
          },
          ['R'] = 'refresh',
          ['?'] = 'show_help',
          ['<'] = 'prev_source',
          ['>'] = 'next_source',
          ['i'] = 'show_file_details',
          ['<C-n>'] = 'next_git_modified',
          ['<C-p>'] = 'prev_git_modified',
        },
      },
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            'thumbs.db',
            'node_modules',
            '__pycache__',
            '.virtual_documents',
            '.git',
            '.python-version',
            '.idea',
          },
          hide_by_pattern = { -- uses glob style patterns
            '.*_cache',
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            '.gitignore',
            '.env',
            '*_playground.py',
          },
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            '.DS_Store',
            --"thumbs.db"
            '__pycache__',
          },
          never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
          },
        },
        follow_current_file = {
          enabled = false,
          leave_dirs_open = true,
        },
        group_empty_dirs = false,
        use_libuv_file_watcher = true,
        window = {
          mappings = {
            ['u'] = 'navigate_up',
            ['C'] = 'set_root',
            ['H'] = 'toggle_hidden',
            ['/'] = 'noop',
            ['f'] = 'noop',
            ['<c-c>'] = 'noop', -- allow to reset hl search
            ['<C-u>'] = { 'scroll_preview', config = { direction = 10 } },
            ['<C-d>'] = { 'scroll_preview', config = { direction = -10 } },
          },
        },
      },
      event_handlers = {
        -- equalize windows after opening or closing the neo-tree window
        {
          event = 'neo_tree_window_after_open',
          handler = function(args)
            if args.position == 'left' or args.position == 'right' then
              vim.cmd('wincmd =')
            end
          end,
        },
        {
          event = 'neo_tree_window_after_close',
          handler = function(args)
            if args.position == 'left' or args.position == 'right' then
              vim.cmd('wincmd =')
            end
          end,
        },
      },
    })

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', 'tf', ':Neotree reveal<CR>', opts)
    vim.keymap.set('n', 'tt', ':Neotree toggle<CR>', opts)
    vim.keymap.set('n', '<C-s>', ':Neotree toggle<CR>', opts)

    vim.api.nvim_create_autocmd('VimEnter', {
      desc = 'Open NeoTree on startup if no files are opened',
      callback = function()
        if vim.fn.argc() == 0 then
          vim.cmd('Neotree reveal')
        end
      end,
    })
  end,
}

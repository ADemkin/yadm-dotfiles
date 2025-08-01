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
      popup_border_style = 'single',
      close_if_last_window = true,
      use_popups_for_input = false, -- use vim's comman line for inputs
      enable_git_status = true,
      git_status_async = true,
      enable_diagnostics = false,
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
      -- A list of functions, each representing a global custom command
      -- that will be available in all sources (if not overridden in `opts[source_name].commands`)
      -- see `:h neo-tree-custom-commands-global`
      commands = {},
      window = {
        position = 'left',
        width = 30,
        mapping_options = {
          noremap = true,
          nowait = true,
        },
        mappings = {
          ['<cr>'] = 'open',
          ['l'] = 'open',
          ['<esc>'] = 'cancel',
          ['p'] = { 'toggle_preview', config = { use_float = true } },
          -- ['P'] = 'toggle_preview', -- enter preview mode, which shows the current node without focusing
          ['S'] = 'open_split',
          ['s'] = 'open_vsplit',
          ['t'] = false, -- disable t
          ['h'] = 'close_node',
          ['X'] = 'close_all_nodes',
          ['a'] = {
            'add',
            config = {
              show_path = 'relative',
            },
          },
          ['A'] = {
            'add_directory', -- also accepts the optional config.show_path option like "add". this also supports BASH style brace expansion.
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
          -- ['<'] = 'prev_source',
          -- ['>'] = 'next_source',
          ['i'] = 'show_file_details',
        },
      },
      nesting_rules = {},
      filesystem = {
        filtered_items = {
          visible = false, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            '.DS_Store',
            'thumbs.db',
            'node_modules',
            '__pycache__',
            '.virtual_documents',
            '.git',
            '.python-version',
          },
          hide_by_pattern = { -- uses glob style patterns
            '.*_cache',
            --"*/src/*/tsconfig.json",
          },
          always_show = { -- remains visible even if other settings would normally hide it
            '.gitignore',
          },
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            '.DS_Store',
            --"thumbs.db"
          },
          never_show_by_pattern = { -- uses glob style patterns
            --".null-ls_*",
          },
        },
        follow_current_file = {
          enabled = false, -- This will find and focus the file in the active buffer every time
          --               -- the current file is changed while the tree is open.
          leave_dirs_open = true, -- `false` closes auto expanded dirs, such as with `:Neotree reveal`
        },
        group_empty_dirs = false, -- when true, empty folders will be grouped together
        use_libuv_file_watcher = true, -- This will use the OS level file watchers to detect changes (default: false)
        -- instead of relying on nvim autocmd events.
        window = {
          mappings = {
            ['u'] = 'navigate_up',
            ['C'] = 'set_root',
            ['H'] = 'toggle_hidden',
            -- ['/'] = 'fuzzy_finder',
            -- ['F'] = 'fuzzy_finder',
            ['D'] = 'fuzzy_finder_directory',
            ['#'] = 'fuzzy_sorter', -- fuzzy sorting using the fzy algorithm
            -- ["D"] = "fuzzy_sorter_directory",
            ['f'] = 'filter_on_submit',
            ['<c-c>'] = 'clear_filter',
            ['[g'] = 'prev_git_modified',
            [']g'] = 'next_git_modified',
            ['o'] = { 'show_help', nowait = false, config = { title = 'Order by', prefix_key = 'o' } },
            ['oc'] = { 'order_by_created', nowait = false },
            ['od'] = { 'order_by_diagnostics', nowait = false },
            ['og'] = { 'order_by_git_status', nowait = false },
            ['om'] = { 'order_by_modified', nowait = false },
            ['on'] = { 'order_by_name', nowait = false },
            ['os'] = { 'order_by_size', nowait = false },
            ['ot'] = { 'order_by_type', nowait = false },
          },
          fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
            ['<down>'] = 'move_cursor_down',
            ['<C-n>'] = 'move_cursor_down',
            ['<up>'] = 'move_cursor_up',
            ['<C-p>'] = 'move_cursor_up',
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
  end,
}

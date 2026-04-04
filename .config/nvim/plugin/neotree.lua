vim.schedule(function()
  vim.pack.add({
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/MunifTanjim/nui.nvim',
    -- snacks.nvim loaded in claude.lua; vim.pack handles duplicate
    'https://github.com/nvim-neo-tree/neo-tree.nvim',
  })

  local snacks = require('snacks')
  local events = require('neo-tree.events')
  local function on_move(data)
    snacks.rename.on_rename_file(data.source, data.destination)
  end
  local function on_window(args)
    if args.position == 'left' or args.position == 'right' then
      vim.cmd('wincmd =')
    end
  end

  require('neo-tree').setup({
    close_if_last_window = true,
    use_popups_for_input = false,
    enable_git_status = true,
    git_status_async = true,
    enable_diagnostics = false,
    enable_modified_markers = false,
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
        with_markers = true,
        indent_marker = '│',
        last_indent_marker = '└',
        highlight = 'NeoTreeIndentMarker',
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
          added = '',
          modified = '',
        },
      },
      symlink_target = {
        enabled = false,
      },
    },
    window = {
      position = 'left',
      width = 30,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ['l'] = 'open',
        ['<esc>'] = 'cancel',
        ['p'] = { 'toggle_preview', config = { use_float = true } },
        ['s'] = 'open_split',
        ['v'] = 'open_vsplit',
        ['t'] = 'noop',
        ['w'] = 'noop',
        ['#'] = 'noop',
        ['h'] = 'close_node',
        ['x'] = 'close_all_subnodes',
        ['e'] = 'expand_all_subnodes',
        ['a'] = { 'add', config = { show_path = 'relative' } },
        ['d'] = 'delete',
        ['r'] = 'rename',
        ['c'] = { 'copy', config = { show_path = 'relative' } },
        ['m'] = { 'move', config = { show_path = 'relative' } },
        ['R'] = 'refresh',
        ['?'] = 'show_help',
        ['i'] = 'show_file_details',
        ['<C-n>'] = 'next_git_modified',
        ['<C-p>'] = 'prev_git_modified',
        ['tj'] = 'next_git_modified',
        ['tk'] = 'prev_git_modified',
      },
    },
    filesystem = {
      filtered_items = {
        visible = false,
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
        hide_by_pattern = {
          '.*_cache',
        },
        always_show = {
          '.gitignore',
          '.env',
          '*_playground.py',
        },
        never_show = {
          '.DS_Store',
          '__pycache__',
        },
        never_show_by_pattern = {},
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
          ['<c-c>'] = 'noop',
          ['<C-u>'] = { 'scroll_preview', config = { direction = 10 } },
          ['<C-d>'] = { 'scroll_preview', config = { direction = -10 } },
        },
      },
    },
    event_handlers = {
      { event = events.NEO_TREE_WINDOW_AFTER_OPEN, handler = on_window },
      { event = events.NEO_TREE_WINDOW_AFTER_CLOSE, handler = on_window },
      { event = events.FILE_MOVED, handler = on_move },
      { event = events.FILE_RENAMED, handler = on_move },
    },
  })

  local opts = { noremap = true, silent = true }
  vim.keymap.set('n', 'tf', ':Neotree reveal<CR>', opts)
  vim.keymap.set('n', '<C-s>', ':Neotree toggle<CR>', opts)
end)

return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('toggleterm').setup({
        size = function(term)
          if term.direction == 'horizontal' then
            return 20
          elseif term.direction == 'vertical' then
            vim.schedule(function()
              vim.cmd('wincmd =') -- equalize window sizes
            end)
            return 80
          end
        end,
        open_mapping = '<c-y>',
        hide_numbers = true,
        autochdir = false,
        start_in_insert = true,
        shade_terminals = false,
        persist_size = false,
        persist_mode = true,
        auto_scroll = false,
        direction = 'vertical', -- 'vertical', 'tab', 'float'
        close_on_exit = true, -- close the terminal window when the process exits
        -- also force toggleterm to respect <C-W> = resize
        on_open = function(term)
          vim.wo[term.window].winfixheight = false
          vim.wo[term.window].winfixwidth = false
        end,
      })

      local trim_spaces = true
      local send = function(motion_type)
        require('toggleterm').send_lines_to_terminal(motion_type, trim_spaces, { args = 1 })
      end
      vim.keymap.set('n', '<leader>ys', function()
        send('single_line')
      end, { noremap = true, silent = true })
      vim.keymap.set('v', '<leader>ys', function()
        send('visual_selection')
      end, { noremap = true, silent = true })

      -- Move terminal with C-w JL and remember position
      local function set_term_direction(new_direction)
        local term = require('toggleterm.terminal').get(1)
        if not term or term.direction == new_direction then
          return
        end
        local mode = vim.api.nvim_get_mode().mode
        term:close()
        vim.cmd('ToggleTerm direction=' .. new_direction)
        if mode == 't' then
          vim.cmd('startinsert')
        end
      end
      vim.keymap.set({ 'n', 't' }, '<C-w>J', function()
        set_term_direction('horizontal')
        vim.cmd('wincmd J')
      end, { noremap = true, silent = true })
      vim.keymap.set({ 'n', 't' }, '<C-w>L', function()
        set_term_direction('vertical')
        vim.cmd('wincmd L')
      end, { noremap = true, silent = true })
    end,
  },
  {
    -- when open nvim from nvim's terminal put it into a new tab in host nvim
    'willothy/flatten.nvim',
    config = true,
    opts = {
      window = {
        open = 'tab',
      },
    },
    lazy = false,
    priority = 1001,
  },
}

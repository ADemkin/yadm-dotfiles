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
      vim.keymap.set('n', '<leader>y', function()
        local term = require('toggleterm.terminal').get(1)
        local current_direction = term.direction
        local new_direction = (current_direction == 'horizontal') and 'vertical' or 'horizontal'
        -- close terminal and reopen with new direction
        vim.cmd('ToggleTerm')
        vim.cmd('ToggleTerm direction=' .. new_direction)
      end, { noremap = true, silent = true })
    end,
  },
  -- 'brianhuster/unnest.nvim',
  {
    'willothy/flatten.nvim',
    config = true,
    -- or pass configuration with
    opts = {
      window = {
        open = 'tab',
      },
    },
    -- Ensure that it runs first to minimize delay when opening file from terminal
    lazy = false,
    priority = 1001,
  },
}

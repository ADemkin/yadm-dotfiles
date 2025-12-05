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

      vim.keymap.set('n', '<M-y>', function()
        local cur = vim.api.nvim_get_current_win()
        local term = require('toggleterm.terminal').get(1)
        if not term then
          -- Terminal not created yet → create horizontal by default
          vim.cmd('ToggleTerm direction=horizontal')
          return
        end
        local new_direction = (term.direction == 'horizontal') and 'vertical' or 'horizontal'
        term:close()
        term:toggle(nil, new_direction)
        vim.api.nvim_set_current_win(cur)
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

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  event = 'VeryLazy',
  config = function()
    -- force toggleterm tp respect <C-W> = resize
    vim.api.nvim_create_autocmd('TermOpen', {
      callback = function()
        vim.wo.winfixheight = false
        vim.wo.winfixwidth = false
      end,
    })
    require('toggleterm').setup({
      size = function(term)
        if term.direction == 'horizontal' then
          return 20
        elseif term.direction == 'vertical' then
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
    vim.api.nvim_create_user_command('ToggleTermOrientation', function()
      local term = require('toggleterm.terminal').get(1)
      local current_direction = term.direction
      local new_direction = (current_direction == 'horizontal') and 'vertical' or 'horizontal'
      -- close terminal and reopen with new direction
      vim.cmd('ToggleTerm')
      vim.cmd('ToggleTerm direction=' .. new_direction)
    end, {})
    vim.keymap.set('n', '<leader>y', ':ToggleTermOrientation<CR>', { noremap = true, silent = true })
  end,
}

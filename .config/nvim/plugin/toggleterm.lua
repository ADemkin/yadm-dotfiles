-- flatten.nvim must be eager: intercepts Neovim RPC server at startup
vim.pack.add({ 'https://github.com/willothy/flatten.nvim' })

require('flatten').setup({
  window = {
    open = 'tab',
  },
})

vim.schedule(function()
  vim.pack.add({
    {
      src = 'https://github.com/akinsho/toggleterm.nvim',
      version = vim.version.range('*'),
    },
  })

  require('toggleterm').setup({
    size = function(term)
      if term.direction == 'horizontal' then
        return 20
      elseif term.direction == 'vertical' then
        vim.schedule(function()
          vim.cmd('wincmd =')
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
    direction = 'vertical',
    close_on_exit = true,
    on_open = function(term)
      vim.wo[term.window].winfixheight = false
      vim.wo[term.window].winfixwidth = false
    end,
  })

  vim.keymap.set('n', '<M-y>', function()
    local cur = vim.api.nvim_get_current_win()
    local term = require('toggleterm.terminal').get(1)
    if not term then
      vim.cmd('ToggleTerm direction=horizontal')
      return
    end
    local new_direction = (term.direction == 'horizontal') and 'vertical' or 'horizontal'
    term:close()
    term:toggle(nil, new_direction)
    vim.api.nvim_set_current_win(cur)
  end, { noremap = true, silent = true })

  local trim_spaces = true
  local send = function(motion_type)
    require('toggleterm').send_lines_to_terminal(motion_type, trim_spaces, { args = 1 })
  end
  vim.keymap.set('n', '<leader>ys', function() send('single_line') end, { noremap = true, silent = true })
  vim.keymap.set('v', '<leader>ys', function() send('visual_selection') end, { noremap = true, silent = true })
end)

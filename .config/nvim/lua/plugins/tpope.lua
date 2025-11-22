return {
  { 'tpope/vim-sleuth' },
  {
    'tpope/vim-fugitive',
    command = 'Git',
    config = function()
      vim.keymap.set('n', 'ts', ':Git<CR>', { noremap = true, silent = true, desc = 'Git status' })
      vim.keymap.set('n', 'tg', ':Git<CR>', { noremap = true, silent = true, desc = 'Git status' })
      local fugitive_float_bufnr
      vim.api.nvim_create_user_command('GitFloat', function()
        local ui = vim.api.nvim_list_uis()[1]
        local relative_border = 0.8
        local width = math.floor(ui.width * relative_border)
        local height = math.floor(ui.height * relative_border)
        local win_config = {
          relative = 'editor',
          width = width,
          height = height,
          col = (ui.width - width) / 2,
          row = (ui.height - height) / 2,
          style = 'minimal',
          focusable = true,
          border = 'single',
        }
        if vim.api.nvim_win_get_buf(0) == fugitive_float_bufnr then
          vim.api.nvim_command('hide')
          return
        end
        if not fugitive_float_bufnr then
          fugitive_float_bufnr = vim.api.nvim_create_buf(false, true)
        end
        vim.api.nvim_open_win(fugitive_float_bufnr, true, win_config)
        vim.cmd(':Gedit :')
      end, {})
      vim.keymap.set('n', '<C-g>', ':GitFloat<CR>', { noremap = true, silent = true, desc = 'Git status' })
    end,
  },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-abolish' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },
}

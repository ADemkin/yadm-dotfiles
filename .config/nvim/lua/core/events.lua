-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Nvim terminal does not start in insert mode by default
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter', 'TermOpen' }, {
  pattern = 'term://*',
  command = 'startinsert',
})

-- Prevent cursor from blinking in terminal mode
vim.api.nvim_create_autocmd('TermOpen', {
  callback = function()
    vim.opt_local.guicursor = ''
  end,
})

-- Restore cursor position when opening a file
vim.api.nvim_create_autocmd('BufReadPost', {
  group = vim.api.nvim_create_augroup('LastPlace', { clear = true }),
  pattern = { '*' },
  desc = 'Remember last cursor place',
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

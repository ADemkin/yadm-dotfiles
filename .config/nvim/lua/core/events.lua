vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('TermEnter', {
  desc = 'Start insert when entering terminal buffer',
  pattern = 'term://*',
  command = 'startinsert',
})

vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Prevent cursor from blinking in terminal mode',
  callback = function()
    vim.opt_local.guicursor = ''
  end,
})

vim.api.nvim_create_autocmd('BufReadPost', {
  desc = 'Remember last cursor place',
  group = vim.api.nvim_create_augroup('LastPlace', { clear = true }),
  pattern = { '*' },
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd({ 'VimResized', 'WinResized' }, {
  desc = 'Resize windows when Vim is resized',
  group = vim.api.nvim_create_augroup('ResizeWindows', { clear = true }),
  callback = function()
    vim.cmd('wincmd =')
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  desc = 'Move help to the right side',
  group = vim.api.nvim_create_augroup('HelpInRightSplit', { clear = true }),
  pattern = '*.txt',
  callback = function()
    if vim.bo.buftype == 'help' then
      vim.cmd('wincmd L')
      vim.cmd('vertical resize 80')
    end
  end,
})

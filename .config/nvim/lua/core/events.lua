vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd('TermEnter', {
  desc = 'Prepare terminal buffer',
  pattern = 'term://*',
  callback = function()
    vim.cmd('startinsert')
  end,
})

vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Set local terminal settings',
  callback = function()
    vim.opt_local.guicursor = ''
    vim.opt_local.spell = false
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

vim.api.nvim_create_autocmd({ 'VimResized' }, {
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
      vim.cmd('vertical resize 84')
    end
  end,
})

vim.api.nvim_create_autocmd('DirChanged', {
  desc = 'Auto activate venv on cd',
  pattern = '*',
  callback = function(event)
    local cwd = event.file
    local venv_candidates = { 'venv', '.venv' }
    for _, venv in ipairs(venv_candidates) do
      local virtual_env = vim.fs.joinpath(cwd, venv)
      if vim.fn.isdirectory(virtual_env) == 1 then
        -- Simulate what actually happens in venv/bin/activate
        vim.fn.setenv('VIRTUAL_ENV', virtual_env)
        local venv_bin = vim.fs.joinpath(virtual_env, 'bin')
        local PATH = vim.fn.getenv('PATH')
        -- On local projects I sometimes need an .src prefix
        vim.fn.setenv('PATH', './src:' .. venv_bin .. ':' .. PATH)
        vim.fn.setenv('PYTHONPATH', cwd)
        return
      end
    end
  end,
})

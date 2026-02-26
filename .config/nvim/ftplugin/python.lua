vim.keymap.set('n', '<leader>yt', require('core.terminal').run_single_test, { noremap = true, desc = 'Run current pytest test in terminal' })
vim.keymap.set('n', '<leader>yf', require('core.terminal').run_module_test, { noremap = true, desc = 'Run current pytest module tests in terminal' })
vim.keymap.set('n', '<leader>yr', require('core.terminal').run_with_python, { noremap = true, desc = 'Run current module with default python' })

_G.NoCompleteAbbrev = function(text)
  vim.g.blink_enabled = false
  vim.schedule(function()
    vim.g.blink_enabled = true
  end)
  return text
end

vim.cmd([[
  iabbrev <expr> pdb    v:lua.NoCompleteAbbrev("breakpoint()\<CR>pass")
  iabbrev <expr> ifname v:lua.NoCompleteAbbrev("if __name__ == '__main__':\<CR>")
  iabbrev <expr> adef v:lua.NoCompleteAbbrev("async def ")
]])

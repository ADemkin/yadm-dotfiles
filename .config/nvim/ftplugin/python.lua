vim.keymap.set('n', '<leader>yt', require('core.terminal').run_single_test, { noremap = true, desc = 'Run current pytest test in terminal' })
vim.keymap.set('n', '<leader>yf', require('core.terminal').run_module_test, { noremap = true, desc = 'Run current pytest module tests in terminal' })

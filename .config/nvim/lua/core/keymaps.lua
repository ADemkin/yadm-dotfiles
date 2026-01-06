-- Set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- For conciseness
local opts = { noremap = true, silent = true }

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- Scroll and center
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)

-- Navigate between splits
vim.keymap.set({ 'n', 't', 'i' }, '<C-k>', '<CMD>wincmd k<CR>', opts)
vim.keymap.set({ 'n', 't', 'i' }, '<C-j>', '<CMD>wincmd j<CR>', opts)
vim.keymap.set({ 'n', 't', 'i' }, '<C-h>', '<CMD>wincmd h<CR>', opts)
vim.keymap.set({ 'n', 't', 'i' }, '<C-l>', '<CMD>wincmd l<CR>', opts)

-- Esc like in classic vim
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
-- C-w like in classic vim
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function(event)
    -- Enter in scrolled terminal goes back into insert mode
    vim.keymap.set('n', '<Return>', 'i', { buffer = event.buf, noremap = true, silent = true })
  end,
})

-- Resize terminal
vim.keymap.set('t', '<A-h>', [[<C-\><C-n><A-h><CR><CR>]], opts)
vim.keymap.set('t', '<A-j>', [[<C-\><C-n><A-j><CR><CR>]], opts)
vim.keymap.set('t', '<A-k>', [[<C-\><C-n><A-k><CR><CR>]], opts)
vim.keymap.set('t', '<A-l>', [[<C-\><C-n><A-l><CR><CR>]], opts)

-- scroll up in terminal like it is in normal mode
vim.keymap.set('t', '<C-u>', '<C-\\><C-n><C-u>', opts)

-- Escape to normal mode in terminal
-- Why not single? If another instance of vim will run inside terminal,
-- then you want to be able to change mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', opts)

-- C-c reset search and highlight
-- remapped by mark plugin
vim.keymap.set('n', '<C-c>', ':nohlsearch<CR>', opts)

-- Command mode without shift
vim.keymap.set('n', ';', ':', { noremap = true })
vim.keymap.set('n', ':', ';', opts)

-- Move lines up/down wit s-j/s-k
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", opts)
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- Delete do not replace current register
vim.keymap.set('n', 'x', '"_x', opts)
vim.keymap.set('v', 'p', '"_dP', opts)
vim.keymap.set('n', 'x', '"_x', opts)

-- Open terminal
-- vim.keymap.set('n', '<leader>t', ':vert terminal<CR>', opts)

-- unbind default LSP keymaps
vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'gri')
vim.keymap.del({ 'n', 'x' }, 'gra')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'grn')

-- Allow Russian layout to control nvim
vim.opt.langmap = table.concat({
  'Ë;~',
  'А;F',
  'Б;<',
  'В;D',
  'Г;U',
  'Д;L',
  'Е;T',
  'З;P',
  'И;B',
  'Й;Q',
  'К;R',
  'Л;K',
  'М;V',
  'Н;Y',
  'О;J',
  'П;G',
  'Р;H',
  'С;C',
  'Т;N',
  'У;E',
  'Ф;A',
  'Ц;W',
  'И;B',
  'Ш;I',
  'Щ;O',
  'Ь;M',
  'Я;Z',
  'а;f',
  'в;d',
  'г;u',
  'д;l',
  'е;t',
  'ж;:',
  'з;p',
  'и;b',
  'й;q',
  'к;r',
  'л;k',
  'м;v',
  'н;y',
  'о;j',
  'п;g',
  'р;h',
  'с;c',
  'т;n',
  'у;e',
  'ф;a',
  'ц;w',
  'ч;x',
  'ш;i',
  'щ;o',
  'ь;m',
  'ё;`',
}, ',')

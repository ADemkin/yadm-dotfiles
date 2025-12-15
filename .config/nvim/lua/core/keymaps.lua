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
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<C-j>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>', opts)

-- Navigate terminal
vim.keymap.set('t', '<C-h>', [[<CMD>wincmd h<CR>]], opts)
vim.keymap.set('t', '<C-j>', [[<CMD>wincmd j<CR>]], opts)
vim.keymap.set('t', '<C-k>', [[<CMD>wincmd k<CR>]], opts)
vim.keymap.set('t', '<C-l>', [[<CMD>wincmd l<CR>]], opts)
vim.keymap.set('i', '<C-h>', [[<CMD>wincmd h<CR>]], opts)
vim.keymap.set('i', '<C-j>', [[<CMD>wincmd j<CR>]], opts)
vim.keymap.set('i', '<C-k>', [[<CMD>wincmd k<CR>]], opts)
vim.keymap.set('i', '<C-l>', [[<CMD>wincmd l<CR>]], opts)
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)

-- Resize terminal
vim.keymap.set('t', '<A-h>', [[<C-\><C-n><A-h><CR><CR>]], opts)
vim.keymap.set('t', '<A-j>', [[<C-\><C-n><A-j><CR><CR>]], opts)
vim.keymap.set('t', '<A-k>', [[<C-\><C-n><A-k><CR><CR>]], opts)
vim.keymap.set('t', '<A-l>', [[<C-\><C-n><A-l><CR><CR>]], opts)

-- scroll up in terminal like it is in normal mode
vim.keymap.set('t', '<C-u>', '<C-\\><C-n><C-u>', opts)

-- Escape to normal mode in terminal
-- Why not single? If another instance of vim will run inside terminal,
-- then you wint be able to change mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', opts)

-- Enter in scrolled terminal goes back into insert mode
vim.keymap.set('n', '<Return>', 'i', opts)

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

-- Navigate quickfix list
vim.keymap.set('n', 'q<Tab>', '<cmd>cnext<CR>', opts)
vim.keymap.set('n', 'q<S-Tab>', '<cmd>cprev<CR>', opts)
vim.keymap.set('n', 'qj', '<cmd>cnext<CR>', opts)
vim.keymap.set('n', 'qk', '<cmd>cprev<CR>', opts)
vim.keymap.set('n', 'qn', '<cmd>cnext<CR>', opts)
vim.keymap.set('n', 'qp', '<cmd>cprev<CR>', opts)
vim.keymap.set('n', '<leader>qn', '<cmd>cnext<CR>', opts)
vim.keymap.set('n', '<leader>qp', '<cmd>cprev<CR>', opts)

-- unbind default LSP keymaps
vim.keymap.del('n', 'grt')
vim.keymap.del('n', 'gri')
vim.keymap.del({ 'n', 'x' }, 'gra')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'grn')

-- Allow russian layout to control nvim
vim.opt.langmap = table.concat({
  'ц;w',
  'Ц;W',
  'у;e',
  'У;E',
  'ф;a',
  'Ф;A',
  'ч;x',
  'с;c',
  'С;C',
  'м;v',
  'М;V',
  'и;b',
  'И;B',
  'н;y',
  'ш;i',
  'Ш;I',
  'щ;o',
  'Щ;O',
  'з;p',
  'З;P',
  'п;g',
  'П;G',
  'р;h',
  'о;j',
  'л;k',
  'д;l',
  'т;n',
  'Т;N',
  'ж;:',
}, ',')

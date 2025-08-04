vim.o.scrolloff = 4
vim.opt.termguicolors = true
vim.o.colorcolumn = '80'
vim.o.cursorline = true
vim.o.cursorcolumn = false

-- do not show mode like -- INSERT -- in the bottom
vim.o.showmode = false

-- show tabline when there are more than one tab opened
vim.o.showtabline = 1

-- allow more horizontal movements - ?
-- vim.o.whichwrap = 'bs<>[]'

-- Pop up menu height (default: 0)
vim.o.pumheight = 10
vim.o.cmdheight = 1

-- wrap words
vim.o.wrap = true
vim.o.linebreak = true

-- Split
vim.o.splitbelow = true
vim.o.splitright = true

-- Show line numbers
vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 1
vim.wo.signcolumn = 'auto'

-- Allow nerdfonts
vim.g.have_nerd_font = true

vim.o.showcmd = true -- Show command in bottom bar

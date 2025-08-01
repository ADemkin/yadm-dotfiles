vim.o.clipboard = 'unnamedplus' -- share clipboard with OS
vim.o.mouse = '' -- disable mouse
vim.o.fileencoding = 'utf-8' -- The encoding written to a file (default: 'utf-8')

vim.o.swapfile = false
vim.o.backspace = 'indent,eol,start'
vim.o.conceallevel = 0
vim.o.backup = false
vim.o.autoread = true

-- time
vim.o.updatetime = 100 -- Decrease update time (default: 4000)
vim.o.timeoutlen = 1000 -- Time to wait for a mapped sequence to complete (in milliseconds) (default: 1000)
vim.o.writebackup = false -- If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited (default: true)
vim.o.undofile = true -- Save undo history (default: false)

-- completion
vim.o.completeopt = 'menuone,noselect' -- default: 'menu,preview'
vim.opt.shortmess:append('c') -- Don't give |ins-completion-menu| messages (default: does not include 'c')
vim.opt.iskeyword:append('-') -- Hyphenated words recognized by searches (default: does not include '-')
vim.opt.formatoptions:remove({ 'c', 'r', 'o' }) -- Don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode. (default: 'croql')

-- runtime
vim.opt.runtimepath:remove('/usr/share/vim/vimfiles') -- Separate Vim plugins from Neovim in case Vim still in use (default: includes this path if Vim is installed)

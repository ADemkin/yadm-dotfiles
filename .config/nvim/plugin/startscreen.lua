-- lazy.nvim: no lazy loading specified (eager)

vim.pack.add({ 'https://github.com/goolord/alpha-nvim' })

local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

dashboard.section.header.val = function()
  return vim.fn.getcwd()
end

dashboard.section.buttons.val = {
  dashboard.button('e', 'New file', ':ene <BAR> startinsert <CR>'),
  dashboard.button('f', 'Find file', ':Telescope find_files<CR>'),
  dashboard.button('g', 'Grep file', ':Grep<CR>'),
  dashboard.button('r', 'Recent', ':Telescope oldfiles<CR>'),
  dashboard.button('s', 'Side tree', ':Neotree toggle<CR>'),
  dashboard.button('p', 'Project switch', ':Telescope whaler<CR>'),
}

alpha.setup(dashboard.opts)

local function getcwd()
  cwd = vim.fn.getcwd()
  return cwd
end

return {
  'goolord/alpha-nvim',
  config = function()
    -- require('alpha').setup(require('alpha.themes.dashboard').config)
    local alpha = require('alpha')
    local dashboard = require('alpha.themes.dashboard')

    -- TODO: center and trim cwd
    -- https://github.com/goolord/alpha-nvim
    dashboard.section.header.val = getcwd

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button('e', 'New file', ':ene <BAR> startinsert <CR>'),
      dashboard.button('f', 'Find file', ':Telescope find_files<CR>'),
      dashboard.button('g', 'Grep file', ':Grep<CR>'),
      dashboard.button('r', 'Recent', ':Telescope oldfiles<CR>'),
      dashboard.button('s', 'Side tree', ':Neotree show<CR>'),
      dashboard.button('p', 'Project switch', ':Telescope whaler<CR>'),
    }

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- -- Disable folding on alpha buffer
    -- vim.cmd([[
    -- autocmd FileType alpha setlocal nofoldenable
    -- ]])
  end,
}

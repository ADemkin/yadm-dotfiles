vim.opt.spelllang = { 'en_us', 'ru' }
vim.opt.spelloptions = 'camel'
-- Defer dict loading: setting spell=true triggers .spl file reads (~40ms)
vim.schedule(function()
  vim.opt.spell = true
end)

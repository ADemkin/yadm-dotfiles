return {
  'kopecmaciej/vi-mongo.nvim',
  lazy = true,
  build = 'brew tap kopecmaciej/vi-mongo && brew install vi-mongo',
  config = function()
    require('vi-mongo').setup()
  end,
  cmd = { 'ViMongo' },
  -- keys = {
  --   { '<leader>vm', '<cmd>ViMongo<cr>', desc = 'ViMongo' },
  -- },
}

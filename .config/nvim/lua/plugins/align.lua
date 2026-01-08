return {
  {
    'nvim-mini/mini.align',
    opts = {
      mappings = {
        start = 'geA',
        start_with_preview = 'gea',
      },
    },
  },
  -- Classic vim allign plugin, but seems like not working with nvim?
  -- {
  --   'junegunn/vim-easy-align',
  --   config = function()
  --     vim.cmd([[
  --       " Start interactive EasyAlign in visual mode (e.g. vipga)
  --       xmap gea <Plug>(EasyAlign)

  --       " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  --       nmap gea <Plug>(EasyAlign)
  --     ]])
  --   end,
  -- },
}

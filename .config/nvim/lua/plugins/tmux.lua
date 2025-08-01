return {
  'aserowy/tmux.nvim',
  config = function()
    return require('tmux').setup({
      navigation = {
        enable_default_keybindings = true,
      },
      resize = {
        enable_default_keybindings = true,
        resize_step_x = 3,
        resize_step_y = 3,
      },
    })
  end,
}

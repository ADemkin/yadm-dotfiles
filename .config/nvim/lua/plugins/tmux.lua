return {
  'aserowy/tmux.nvim',
  lazy = false,
  config = function()
    return require('tmux').setup({
      navigation = {
        cycle_navigation = false,
        enable_default_keybindings = true,
        persist_zoom = true,
      },
      resize = {
        enable_default_keybindings = true,
        resize_step_x = 3,
        resize_step_y = 3,
      },
    })
  end,
}

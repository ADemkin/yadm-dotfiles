-- lazy.nvim: lazy=false (eager)

vim.pack.add({ 'https://github.com/aserowy/tmux.nvim' })

require('tmux').setup({
  navigation = {
    enable_default_keybindings = true,
    persist_zoom = true,
  },
  resize = {
    enable_default_keybindings = true,
    resize_step_x = 3,
    resize_step_y = 3,
  },
})

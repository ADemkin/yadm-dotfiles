vim.schedule(function()
  vim.pack.add({
    'https://github.com/FooSoft/vim-argwrap',
    'https://github.com/nvim-treesitter/nvim-treesitter', -- dep for treesj
    'https://github.com/Wansmer/treesj',
  })

  vim.g.argwrap_tail_comma = 1

  require('treesj').setup({
    use_default_keymaps = false,
    max_join_length = 512,
  })

  vim.keymap.set('n', '<leader>j', function()
    if require('treesj.langs')[vim.bo.filetype] then
      require('treesj').toggle()
    else
      vim.cmd('ArgWrap')
    end
  end)

  vim.keymap.set('n', '<leader>J', function()
    if require('treesj.langs')[vim.bo.filetype] then
      require('treesj').toggle({ split = { recursive = true } })
    else
      vim.cmd('ArgWrap')
    end
  end)
end)

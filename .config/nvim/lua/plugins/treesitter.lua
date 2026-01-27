return {
  'nvim-treesitter/nvim-treesitter',
  -- dependencies = {
  --   'nvim-treesitter/nvim-treesitter-context',
  -- },
  event = { 'BufReadPre', 'BufNewFile' },
  build = ':TSUpdate',
  main = 'nvim-treesitter.configs', -- Sets main module to use for opts
  -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
  opts = {
    ensure_installed = {
      'lua',
      'python',
      'javascript',
      'typescript',
      'vimdoc',
      'vim',
      'regex',
      'sql',
      'dockerfile',
      'toml',
      'json',
      'go',
      'gitignore',
      'graphql',
      'yaml',
      'make',
      'cmake',
      'markdown',
      'markdown_inline',
      'bash',
      'tsx',
      'css',
      'html',
      'comment',
    },
    -- Autoinstall languages that are not installed
    auto_install = true,
    highlight = {
      enable = true,
      disable = { 'tmux' },
    },
    indent = { enable = true },
    config = function(_, opts)
      require('nvim-treesitter.configs').setup(opts)
    end,
  },
}

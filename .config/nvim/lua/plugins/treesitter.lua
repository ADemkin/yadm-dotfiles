-- return {
--   'nvim-treesitter/nvim-treesitter',
--   lazy = false,
--   branch = 'main',
--   build = ':TSUpdate',
--   opts = {
--     ensure_installed = {
--       'lua',
--       'python',
--       'javascript',
--       'typescript',
--       'vimdoc',
--       'vim',
--       'regex',
--       'sql',
--       'dockerfile',
--       'toml',
--       'json',
--       'go',
--       'gitignore',
--       'graphql',
--       'yaml',
--       'make',
--       'cmake',
--       'markdown',
--       'markdown_inline',
--       'bash',
--       'tsx',
--       'css',
--       'html',
--       'comment',
--     },
--     -- Autoinstall languages that are not installed
--     auto_install = true,
--     highlight = {
--       enable = true,
--       disable = { 'tmux' },
--     },
--     indent = {
--       enable = true,
--       disable = { 'python', 'htmldjango' },
--     },
--   },
--   config = function(_, opts)
--     require('nvim-treesitter').install(opts.ensure_installed)
--     require('nvim-treesitter.config').setup(opts)
--   end,
-- }

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  -- dependencies = {
  --   'nvim-treesitter/nvim-treesitter-context',
  -- },
  config = function()
    -- Auto-install parsers and enable treesitter highlight/indent per filetype.
    -- See: https://github.com/nvim-treesitter/nvim-treesitter/discussions/7927
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { '*' },
      callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end
        if not vim.treesitter.language.add(lang) then
          local available = vim.g.ts_available or require('nvim-treesitter').get_available()
          if not vim.g.ts_available then
            vim.g.ts_available = available
          end
          if vim.tbl_contains(available, lang) then
            require('nvim-treesitter').install(lang):wait(30 * 1000)
          end
        end
        if vim.treesitter.language.add(lang) then
          vim.treesitter.start(args.buf, lang)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}

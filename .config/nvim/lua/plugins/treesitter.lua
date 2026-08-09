-- htmldjango highlighter is more capable than jinja
vim.treesitter.language.register('jinja', 'htmldjango')
vim.treesitter.language.register('html', 'htmldjango')

local ENSURE_INSTALLED_FTS = {
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
  'htmldjango',
  'jinja',
  'jinja_inline',
  'comment',
  'templ',
}

local function ensure_installed(ft)
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
      require('nvim-treesitter').install(lang)
    end
  end
  return lang
end

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    -- Auto-install parsers and enable treesitter highlight/indent per filetype.
    -- See: https://github.com/nvim-treesitter/nvim-treesitter/discussions/7927
    for _, ft in ipairs(ENSURE_INSTALLED_FTS) do
      pcall(ensure_installed, ft)
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { '*' },
      callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype
        local lang = ensure_installed(ft)
        if not lang then
          return
        end
        if vim.treesitter.language.add(lang) then
          vim.treesitter.start(buf, lang)
        end
      end,
    })
  end,
}

-- PackChanged hook must be outside vim.schedule to fire on install/update

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd('TSUpdate')
    end
  end,
})

vim.schedule(function()
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
    'comment',
  }

  vim.pack.add({
    {
      src = 'https://github.com/nvim-treesitter/nvim-treesitter',
      version = 'main',
    },
  })

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
        require('nvim-treesitter').install(lang):wait(30 * 1000)
      end
    end
    return lang
  end

  for _, ft in ipairs(ENSURE_INSTALLED_FTS) do
    pcall(ensure_installed, ft)
  end

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { '*' },
    callback = function(args)
      local ft = vim.bo[args.buf].filetype
      local lang = ensure_installed(ft)
      if not lang then
        return
      end
      if vim.treesitter.language.add(lang) then
        vim.treesitter.start(args.buf, lang)
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end)

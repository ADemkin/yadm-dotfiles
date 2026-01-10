local function find_venv_path(startpath)
  local venv_candidates = { 'venv', '.venv' }
  for _, venv in ipairs(venv_candidates) do
    local venv_path = vim.fs.joinpath(startpath, venv)
    local exists = vim.fn.glob(venv_path) ~= ''
    if exists then
      return venv_path
    end
  end
  return nil
end

local function on_new_config(new_config, new_root_dir)
  local venv_path = find_venv_path(new_root_dir)
  if not venv_path then
    return
  end
  new_config.settings.python.pythonPath = vim.fs.joinpath(venv_path, 'bin', 'python')
end

return {
  -- docs/configuration/language-server-settings.md
  -- https://docs.basedpyright.com/latest/configuration/language-server-settings/
  on_new_config = on_new_config,
  handlers = {
    ['textDocument/publishDiagnostics'] = function(...) end,
  },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'basic', -- "off", "basic", "standard", "strict", "recommended", "all"
      },
    },
  },
}

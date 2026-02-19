local python = require('utils.python')

local function on_new_config(new_config, new_root_dir)
  local venv_path = python.find_venv_path(new_root_dir)
  if venv_path then
    new_config.settings.python.pythonPath = vim.fs.joinpath(venv_path, 'bin', 'python')
  end
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
        diagnosticMode = 'workspace', -- ["openFilesOnly", "workspace"]
        typeCheckingMode = 'basic', -- "off", "basic", "standard", "strict", "recommended", "all"
      },
    },
  },
}

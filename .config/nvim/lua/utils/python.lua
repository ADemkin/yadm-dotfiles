M = {}

M.find_venv_path = function(cwd)
  local venv_candidates = { 'venv', '.venv' }
  for _, venv in ipairs(venv_candidates) do
    local venv_path = vim.fs.joinpath(cwd, venv)
    if vim.fn.isdirectory(venv_path) == 1 then
      return venv_path
    end
  end
  return nil
end

return M

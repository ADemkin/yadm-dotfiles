local ts_utils = require('nvim-treesitter.ts_utils')

local function get_function_name()
  local node = ts_utils.get_node_at_cursor()
  local steps = 0
  local MAXSTEPS = 40
  while node do
    steps = steps + 1
    assert(steps < MAXSTEPS)
    local node_type = node:type()

    if
      node_type == 'function_definition' -- Python
      or node_type == 'function_declaration' -- Lua, JS
      or node_type == 'method_definition' -- JS
      or node_type == 'function' -- JS
    then
      local name_node = node:field('name')[1]
      if name_node then
        return vim.treesitter.get_node_text(name_node, 0)
      end
    end
    if node_type == 'decorated_definition' then
      node = node:field('definition')[1]
    else
      node = node:parent()
    end
  end
  return nil
end

local function get_module_name_and_path()
  local name = vim.api.nvim_buf_get_name(0)
  return vim.fn.fnamemodify(name, ':t'), vim.fn.fnamemodify(name, ':.')
end

local function build_pytest_command(module_path, function_name)
  local command = 'pytest'
  if module_path ~= nil then
    command = command .. ' ' .. module_path
  end
  if function_name ~= nil then
    command = command .. ' -k ' .. function_name
  end
  return command
end

local function execute_in_terminal(command)
  vim.cmd('TermExec cmd="' .. command .. '"')
end

local function run_single_test()
  local module_name, module_path = get_module_name_and_path()
  if not vim.startswith(module_name, 'test_') then
    print('Module is not a test: ' .. module_name)
    return
  end
  local function_name = get_function_name()
  if function_name == nil then
    print('Function name not found')
    return
  end
  local command = build_pytest_command(module_path, function_name)
  execute_in_terminal(command)
end

local function run_module_test()
  local module_name, module_path = get_module_name_and_path()
  if not vim.startswith(module_name, 'test_') then
    print('Module is not a test: ' .. module_name)
    return
  end
  local command = build_pytest_command(module_path)
  execute_in_terminal(command)
end

return {
  run_single_test = run_single_test,
  run_module_test = run_module_test,
}

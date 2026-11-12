local function get_function_name()
  local node = vim.treesitter.get_node()
  local steps = 0
  local MAXSTEPS = 40
  while node do
    steps = steps + 1
    if steps >= MAXSTEPS then
      return nil
    end
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

local function get_module_path()
  local name = vim.api.nvim_buf_get_name(0)
  return vim.fn.fnamemodify(name, ':.')
end

local function build_pytest_command(module_path, function_name)
  local command = 'pytest'
  if module_path ~= nil then
    command = command .. ' ' .. vim.fn.shellescape(module_path)
  end
  if function_name ~= nil then
    command = command .. ' -k ' .. vim.fn.shellescape(function_name)
  end
  return command
end

local function execute_in_terminal(command)
  require('toggleterm').exec(command)
end

local function run_single_test()
  local module_path = get_module_path()
  local function_name = get_function_name()
  if function_name == nil then
    print('Function name not found')
    return
  end
  local command = build_pytest_command(module_path, function_name)
  execute_in_terminal(command)
end

local function run_module_test()
  local module_path = get_module_path()
  local command = build_pytest_command(module_path)
  execute_in_terminal(command)
end

local function run_with_python()
  local module_path = get_module_path()
  execute_in_terminal('python ' .. vim.fn.shellescape(module_path))
end

return {
  run_single_test = run_single_test,
  run_module_test = run_module_test,
  run_with_python = run_with_python,
}

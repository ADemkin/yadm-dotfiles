local ts_utils = require('nvim-treesitter.ts_utils')

local function get_function_name()
  local node = ts_utils.get_node_at_cursor()
  while node do
    local node_type = node:type()

    -- Try common function-like node types
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
    node = node:parent()
  end
  return nil
end

vim.keymap.set('n', '<leader>tt', function()
  local name = get_function_name()
  if name == nil then
    return
  end
  local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':.')
  local command = ''
  if vim.bo.filetype == 'python' then
    if vim.startswith(name, 'test_') then
      command = 'pytest ' .. path .. ' -k ' .. name
    end
  else
    print('Filetype not supported: ' .. vim.bo.filetype)
    return
  end
  if command == '' then
    print('Test not found')
    return
  end
  vim.cmd('TermExec cmd="' .. command .. '"')
end, { noremap = true, silent = true, desc = 'Run current pytest test in terminal' })

-- Toggle wrap/unwrap try/except around the current line (Python) using Tree-sitter.
local function _get_node_at_cursor(bufnr, row, col)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, 'python')
  if not ok or not parser then
    return nil
  end
  local tree = parser:parse()[1]
  if not tree then
    return nil
  end
  local root = tree:root()
  -- use named descendant to skip punctuation nodes
  return root:named_descendant_for_range(row, col, row, col)
end

local function find_ancestor_of_type(node, target_type)
  while node do
    if node:type() == target_type then
      return node
    end
    node = node:parent()
  end
  return nil
end

local function get_node_children_by_type(node, t)
  local out = {}
  for i = 0, node:named_child_count() - 1 do
    local ch = node:named_child(i)
    if ch and ch:type() == t then
      table.insert(out, ch)
    end
  end
  return out
end

local function get_lines(bufnr, srow, erow)
  return vim.api.nvim_buf_get_lines(bufnr, srow, erow + 1, false)
end

local function replace_lines(bufnr, srow, erow, new_lines)
  vim.api.nvim_buf_set_lines(bufnr, srow, erow + 1, false, new_lines)
end

local function leading_ws(s)
  return s:match('^%s*') or ''
end

local function min_common_indent(lines)
  local min = nil
  for _, ln in ipairs(lines) do
    if ln:match('%S') then
      local ws = leading_ws(ln)
      if not min or #ws < #min then
        min = ws
      end
    end
  end
  return min or ''
end

local function toggle_try()
  local bufnr = vim.api.nvim_get_current_buf()
  local cur = vim.api.nvim_win_get_cursor(0)
  local row = cur[1] - 1
  local col = cur[2]
  local node = _get_node_at_cursor(bufnr, row, col)

  local try_node = nil
  if node then
    try_node = find_ancestor_of_type(node, 'try_statement')
  end

  if try_node then
    -- UNWRAP: replace entire try_statement with the suite's contents
    -- find the first suite child (that's the try-block)
    local suite = nil
    for i = 0, try_node:named_child_count() - 1 do
      local ch = try_node:named_child(i)
      if ch and ch:type() == 'block' or ch and ch:type() == 'suite' then
        suite = ch
        break
      end
    end
    -- if suite not found, try more generically: find first 'suite' among descendants
    if not suite then
      local candidates = get_node_children_by_type(try_node, 'suite')
      suite = candidates[1]
    end
    if not suite then
      -- fallback: do nothing
      vim.notify('Could not find try suite to unwrap', vim.log.levels.WARN)
      return
    end

    local srow, scol, erow, ecol = suite:range()
    local try_srow, try_scol = try_node:range()
    local block_lines = get_lines(bufnr, srow, erow)

    -- compute indentation to remove (common indent inside suite)
    local common = min_common_indent(block_lines)
    -- if common is empty, try to remove one shiftwidth level
    if common == '' then
      local sh = vim.bo[bufnr].shiftwidth
      if sh == 0 then
        sh = vim.o.shiftwidth
      end
      common = string.rep(' ', sh and sh > 0 and sh or 4)
    end

    -- base indentation = indentation of try line
    local try_line = get_lines(bufnr, try_srow, try_srow)[1] or ''
    local base_indent = leading_ws(try_line)

    -- normalize lines: remove common prefix then prepend base_indent
    local new_lines = {}
    for _, ln in ipairs(block_lines) do
      if ln:match('^%s*$') then
        table.insert(new_lines, base_indent) -- preserve blank line (as indentation)
      else
        local stripped = ln
        if stripped:sub(1, #common) == common then
          stripped = stripped:sub(#common + 1)
        else
          -- as fallback, remove any leading whitespace up to common length
          stripped = stripped:gsub('^%s+', '')
        end
        table.insert(new_lines, base_indent .. stripped)
      end
    end

    -- Replace the whole try_statement (not only suite) with the new_lines
    local tr_srow, tr_scol, tr_erow, tr_ecol = try_node:range()
    replace_lines(bufnr, tr_srow, tr_erow, new_lines)

    -- Place cursor:
    local new_cursor_row
    local new_cursor_col
    -- If cursor was inside the try suite originally, try to map to corresponding inner line
    if row >= srow and row <= erow then
      local relative = row - srow
      new_cursor_row = tr_srow + relative
      -- compute original col relative to common removed
      local original_line = get_lines(bufnr, srow + relative, srow + relative)[1] or ''
      local orig_ws = leading_ws(original_line)
      local col_offset = math.max(0, col - #common)
      new_cursor_col = #base_indent + (col_offset >= 0 and col_offset or 0)
    else
      -- cursor was outside try suite (e.g., inside except) -> place at first line
      new_cursor_row = tr_srow
      new_cursor_col = #base_indent
    end

    -- clamp
    new_cursor_row = math.max(0, new_cursor_row)
    new_cursor_col = math.max(0, new_cursor_col)

    -- set cursor (convert to 1-based row)
    vim.api.nvim_win_set_cursor(0, { new_cursor_row + 1, new_cursor_col })
  else
    -- WRAP current line with try/except
    local line = get_lines(bufnr, row, row)[1] or ''
    local base_indent = leading_ws(line)
    local content = line:sub(#base_indent + 1)

    local sh = vim.bo[bufnr].shiftwidth
    if sh == 0 then
      sh = vim.o.shiftwidth
    end
    if not sh or sh == 0 then
      sh = 4
    end
    local indent_unit = string.rep(' ', sh)

    local try_line = base_indent .. 'try:'
    local inner_line = base_indent .. indent_unit .. content
    local except_line = base_indent .. 'except Exception as err:'
    local brk_line = base_indent .. indent_unit .. 'breakpoint()'
    local pass_line = base_indent .. indent_unit .. 'pass'

    local new_lines = { try_line, inner_line, except_line, brk_line, pass_line }

    replace_lines(bufnr, row, row, new_lines)

    -- place cursor inside inner line at start of code (after base_indent + indent_unit)
    local new_row = row + 1 -- inner_line is the second line inserted
    local new_col = #base_indent + #indent_unit
    vim.api.nvim_win_set_cursor(0, { new_row + 1, new_col })
  end
end

vim.keymap.set('n', '<C-p>', toggle_try, { noremap = true, silent = true })

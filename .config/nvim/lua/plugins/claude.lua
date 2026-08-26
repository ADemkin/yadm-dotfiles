-- TODO: check https://github.com/folke/sidekick.nvim

local function equalize_after(fn, ...)
  local result = { fn(...) }
  vim.schedule(function()
    vim.cmd('wincmd =')
  end)
  return unpack(result)
end

return {
  'coder/claudecode.nvim',
  opts = {
    terminal = {
      split_width_percentage = 0.5,
      diff_split_width_percentage = 0.2,
      provider = 'native',
    },
  },
  config = function(_, opts)
    require('claudecode').setup(opts)

    -- Monkeypatch: make Claude terminal split like a normal buffer.
    -- Plugin hardcodes `botright <width>vsplit` which ignores `wincmd =`.
    -- We replace the vsplit logic to use plain vsplit + equalize.
    local native = require('claudecode.terminal.native')
    local orig_open = native.open
    local orig_simple_toggle = native.simple_toggle
    local orig_focus_toggle = native.focus_toggle

    -- Patch effective_config to remove the hardcoded width before each call.
    -- Setting split_width_percentage to 0.5 then equalizing gives true 50/50.
    native.open = function(...)
      return equalize_after(orig_open, ...)
    end
    native.simple_toggle = function(...)
      return equalize_after(orig_simple_toggle, ...)
    end
    native.focus_toggle = function(...)
      return equalize_after(orig_focus_toggle, ...)
    end
  end,
  keys = {
    { '<leader>a', nil, desc = 'AI/Claude Code' },
    { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
    { '<C-\\>', '<cmd>ClaudeCode<cr>', mode = { 'n', 't' }, desc = 'Toggle Claude' },
    { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
    { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
    { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
    { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
    { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
    {
      '<leader>as',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
    },
    -- Diff management
    { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}

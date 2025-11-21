return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  config = function()
    local function hide_in_width()
      return vim.fn.winwidth(0) > 100
    end
    local function hide_in_terminal()
      return vim.bo.buftype ~= 'terminal'
    end

    local filename = {
      'filename',
      file_status = true,
      path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
      cond = hide_in_terminal,
    }

    local diagnostics = {
      'diagnostics',
      sources = { 'nvim_diagnostic' },
      sections = { 'error', 'warn' },
      symbols = { error = '', warn = '', info = '', hint = '' },
      colored = true,
      update_in_insert = false,
      always_visible = false,
      cond = hide_in_width,
    }

    local diff = {
      'diff',
      colored = false,
      symbols = { added = '+', modified = '±', removed = '-' }, -- changes diff symbols
      cond = hide_in_width,
    }

    require('lualine').setup({
      options = {
        icons_enabled = false,
        section_separators = { left = '', right = '' },
        component_separators = { left = '|', right = '|' },
        disabled_filetypes = { 'alpha', 'neo-tree', 'dbui' },
        always_divide_middle = true,
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = { filename },
        lualine_x = {
          diagnostics,
          diff,
          {
            'filetype',
            cond = hide_in_width,
          },
        },
        lualine_y = {
          {
            'location',
            cond = hide_in_terminal,
          },
        },
        lualine_z = {
          {
            'progress',
            cond = hide_in_terminal,
          },
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
          {
            'filename',
            path = 1,
            cond = hide_in_terminal,
          },
        },
        lualine_x = {
          {
            'location',
            cond = hide_in_terminal,
            padding = 0,
          },
        },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { 'fugitive' },
    })
  end,
}

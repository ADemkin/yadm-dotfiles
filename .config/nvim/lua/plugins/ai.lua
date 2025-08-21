return {
  -- {
  --   'github/copilot.vim',
  --   config = function()
  --     vim.g.copilot_no_tab_map = true
  --     vim.g.copilot_assume_mapped = true
  --     vim.keymap.set('i', '<C-e>', 'copilot#Accept("\\<CR>")', { silent = true, expr = true, script = true, replace_keycodes = false })

  --     vim.keymap.set('n', '<Leader>cd', ':Copilot disable<CR>', { noremap = true })
  --     vim.keymap.set('n', '<Leader>ce', ':Copilot enable<CR>', { noremap = true })
  --     vim.keymap.set('n', '<Leader>cc', ':Copilot panel<CR>', { noremap = true })
  --   end,
  -- },
  -- lua version of copilot
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          keymap = {
            accept = '<tab>',
            accept_word = false,
            accept_line = false,
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-c>',
          },
        },
      })

      -- Disable copilot when blink completion is active
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuClose',
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
  },
  -- {
  --   'yetone/avante.nvim',
  --   build = 'make',
  --   event = 'VeryLazy',
  --   version = false, -- Never set this value to "*"! Never!
  --   opts = {
  --     -- add any opts here
  --     -- for example
  --     provider = 'openai',
  --     -- provider = 'claude',
  --     -- providers = {
  --     --   claude = {
  --     --     endpoint = 'https://api.anthropic.com',
  --     --     model = 'claude-sonnet-4-20250514',
  --     --     timeout = 30000, -- Timeout in milliseconds
  --     --     extra_request_body = {
  --     --       temperature = 0.75,
  --     --       max_tokens = 20480,
  --     --     },
  --     --   },
  --     --   moonshot = {
  --     --     endpoint = 'https://api.moonshot.ai/v1',
  --     --     model = 'kimi-k2-0711-preview',
  --     --     timeout = 30000, -- Timeout in milliseconds
  --     --     extra_request_body = {
  --     --       temperature = 0.75,
  --     --       max_tokens = 32768,
  --     --     },
  --     --   },
  --     -- },
  --   },
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'MunifTanjim/nui.nvim',
  --     --- The below dependencies are optional,
  --     'echasnovski/mini.pick', -- for file_selector provider mini.pick
  --     'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
  --     'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
  --     'ibhagwan/fzf-lua', -- for file_selector provider fzf
  --     'stevearc/dressing.nvim', -- for input provider dressing
  --     'folke/snacks.nvim', -- for input provider snacks
  --     'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
  --     'zbirenbaum/copilot.lua', -- for providers='copilot'
  --     {
  --       -- support for image pasting
  --       'HakonHarnes/img-clip.nvim',
  --       event = 'VeryLazy',
  --       opts = {
  --         -- recommended settings
  --         default = {
  --           embed_image_as_base64 = false,
  --           prompt_for_file_name = false,
  --           drag_and_drop = {
  --             insert_mode = true,
  --           },
  --         },
  --       },
  --     },
  --     {
  --       -- Make sure to set this up properly if you have lazy=true
  --       'MeanderingProgrammer/render-markdown.nvim',
  --       opts = {
  --         file_types = { 'markdown', 'Avante' },
  --       },
  --       ft = { 'markdown', 'Avante' },
  --     },
  --   },
  -- },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    config = function()
      require('CopilotChat').setup({})
      vim.api.nvim_create_autocmd('BufEnter', {
        desc = 'Settings for Copilot Chat',
        pattern = 'copilot-chat',
        callback = function()
          vim.opt_local.spell = false
          vim.opt_local.colorcolumn = ''
        end,
      })
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    event = 'VeryLazy',
  },
}

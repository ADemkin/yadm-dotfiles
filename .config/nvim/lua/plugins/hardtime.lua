return {
  'm4xshen/hardtime.nvim',
  lazy = false,
  config = function()
    local function is_enabled(stopwords)
      local cwd = vim.fn.getcwd()
      for _, word in ipairs(stopwords) do
        if string.find(cwd, word) then
          return false
        end
      end
      return true
    end
    local stopwords = {
      'moderation',
    }
    local enabled = is_enabled(stopwords)
    local enabled_str = is_enabled and 'enabled' or 'disabled'
    vim.notify('hardtime is ' .. enabled_str)
    require('hardtime').setup({
      enabled = enabled,
    })
  end,
}

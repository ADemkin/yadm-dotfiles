return {
  'm4xshen/hardtime.nvim',
  lazy = false,
  config = function()
    local function is_enabled(stopwords, cwd)
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
    local cwd = vim.fn.getcwd()
    local enabled = is_enabled(stopwords, cwd)
    vim.notify('hardtime is ' .. tostring(enabled) .. ' for ' .. cwd)
    require('hardtime').setup({
      enabled = enabled,
    })
  end,
}

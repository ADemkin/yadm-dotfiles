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
      'ml-platform',
    }
    require('hardtime').setup({
      enabled = is_enabled(stopwords),
     disabled_filetypes = {
        ["fugitive"] = true,
      })
  end,
}

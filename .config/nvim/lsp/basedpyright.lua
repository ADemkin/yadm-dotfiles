return {
  -- docs/configuration/language-server-settings.md
  -- https://docs.basedpyright.com/latest/configuration/language-server-settings/
  handlers = {
    ['textDocument/publishDiagnostics'] = function(...) end,
  },
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'basic', -- "off", "basic", "standard", "strict", "recommended", "all"
      },
    },
  },
}

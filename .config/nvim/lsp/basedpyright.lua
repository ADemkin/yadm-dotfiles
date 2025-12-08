return {
  -- docs/configuration/language-server-settings.md
  -- https://docs.basedpyright.com/latest/configuration/language-server-settings/
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = 'off', -- "off", "basic", "standard", "strict", "recommended", "all"
      },
    },
  },
}

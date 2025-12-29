local api = require('utils.dimmer.api')

vim.api.nvim_create_user_command('Dim', function(opts)
  local args = vim.split(opts.args, '%s+')
  if #args ~= 3 then
    vim.notify('Usage: :DimTheme <k_chroma> <k_light> <curve>', vim.log.levels.ERROR)
    return
  end

  local k_chroma = tonumber(args[1])
  local k_light = tonumber(args[2])
  local curve = tonumber(args[3])

  if not (k_chroma and k_light and curve) then
    vim.notify('All arguments must be numbers', vim.log.levels.ERROR)
    return
  end

  -- clamp defensively
  k_chroma = math.max(0, math.min(1, k_chroma))
  k_light = math.max(0, math.min(1, k_light))

  api.set_tint(k_chroma, k_light, curve)
end, {
  nargs = '+',
  desc = 'Dim current colorscheme perceptually (k_chroma k_light curve)',
})

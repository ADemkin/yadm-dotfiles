-- dim/commands.lua
local api = require('utils.dimmer.api')

vim.api.nvim_create_user_command('Dim', function(opts)
  local args = vim.split(opts.args, '%s+')

  if args[1] == 'enable' then
    api.enable()
    return
  end

  if args[1] == 'disable' then
    api.disable()
    return
  end

  if args[1] == 'toggle' then
    api.toggle()
    return
  end

  if args[1] == 'start' then
    api.start()
    return
  end

  if args[1] == 'stop' then
    api.stop()
    return
  end

  if args[1] == 'state' then
    vim.print(api.get_state())
    return
  end

  if args[1] == 'tint' then
    if #args < 2 then
      vim.notify('Usage: :Dim tint <amount>', vim.log.levels.ERROR)
      return
    end

    local k = tonumber(args[2])
    if not k then
      vim.notify('amount must be a number', vim.log.levels.ERROR)
      return
    end

    if k < 0 or k > 1 then
      vim.notify('amount must be in range 0..1', vim.log.levels.ERROR)
      return
    end

    api.set_tint(k)
    return
  end

  vim.notify('Dim commands: enable | disable | toggle | start | stop | state | tint <amount>', vim.log.levels.INFO)
end, {
  nargs = '+',
  complete = function(_, cmdline)
    if cmdline:match('^Dim%s+[^%s]*$') then
      return { 'enable', 'disable', 'toggle', 'tint', 'start', 'stop', 'state' }
    end
  end,
})

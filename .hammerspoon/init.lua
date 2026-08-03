hs.hotkey.bind({ 'alt' }, 'e', function()
  hs.notify.new({ title = 'Hammerspoon 2', informativeText = 'Hello World' }):send()
end)

-- auto reload config on change
local reloader = hs.loadSpoon('ReloadConfiguration')
reloader:start()

-- automatically route url to browser
-- patterns are Lua patterns (substring match), not regex or glob
-- docs: https://www.lua.org/pil/20.2.html
-- %.  literal dot        (regex \.)
-- .   any single char    (regex .)
-- *   zero or more of previous char
-- %w %d %a  character classes (word, digit, alpha)
-- ^/$ anchor to start/end
local dispatcher = hs.loadSpoon('URLDispatcher')
local arc = 'company.thebrowser.Browser'
dispatcher.url_patterns = {
  {
    {
      '%.wildberries%.ru',
      '%.wb%.ru',
      '%.rwb%.ru',
    },
    arc,
  },
}
dispatcher:start()

-- Toggle Happ VPN (service name: Happ)
hs.hotkey.bind({ 'cmd', 'shift' }, 'v', function()
  local output = hs.execute("scutil --nc status 'Happ' | head -1")
  if output:match('Disconnected') then
    hs.execute("scutil --nc start 'Happ'")
    hs.alert.show('Happ On')
    return
  end
  hs.execute("scutil --nc stop 'Happ'")
  hs.alert.show('Happ Off')
end)

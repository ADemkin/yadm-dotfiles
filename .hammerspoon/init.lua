require('hs.ipc')

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

-- Session time tracker (menubar: total | current session)
hs.loadSpoon('SessionTimer'):start()

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

-- Toggle OpenVPN Connect (via status bar menu)
hs.hotkey.bind({ 'cmd', 'shift' }, 'o', function()
  local app = hs.application.get('org.openvpn.client.app')
  if not app then
    hs.alert.show('OpenVPN not running')
    return
  end

  local ax = hs.axuielement.applicationElement(app)
  local extrasBar = ax:attributeValue('AXChildren')[3]
  local trayItem = extrasBar:attributeValue('AXChildren')[1]

  trayItem:performAction('AXPress')

  hs.timer.doAfter(0.1, function()
    local menu = trayItem:attributeValue('AXChildren')
    if not menu or not menu[1] then
      hs.alert.show('OpenVPN menu failed')
      return
    end

    local items = menu[1]:attributeValue('AXChildren')
    for _, mi in ipairs(items) do
      local title = mi:attributeValue('AXTitle') or ''
      if title == 'Connect' then
        mi:performAction('AXPress')
        hs.alert.show('OpenVPN On')
        return
      elseif title == 'Disconnect' then
        mi:performAction('AXPress')
        hs.alert.show('OpenVPN Off')
        return
      end
    end
    hs.alert.show('OpenVPN toggle not found')
  end)
end)

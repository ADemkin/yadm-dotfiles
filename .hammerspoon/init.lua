require('hs.ipc')

-- hs.hotkey.bind({ 'alt' }, 'e', function()
--   hs.notify.new({ title = 'Hammerspoon 2', informativeText = 'Hello World' }):send()
-- end)

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
-- dispatcher:start()

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

-- Recursively search an AX element tree for the first element matching predicate.
-- The OpenVPN Connect UI is a WKWebView, so the pin dialog sits ~25 levels
-- deep in the AX tree (nested divs), not in its own AXWindow/AXSheet.
local function findAxElement(el, predicate, depth)
  depth = depth or 0
  if not el or depth > 40 then
    return nil
  end
  if predicate(el) then
    return el
  end
  for _, child in ipairs(el:attributeValue('AXChildren') or {}) do
    local found = findAxElement(child, predicate, depth + 1)
    if found then
      return found
    end
  end
  return nil
end

-- Fill OpenVPN's "Enter Pin" dialog from $VPN_CONNECT_PIN and submit it.
-- Polls briefly since the dialog appears asynchronously after Connect.
-- Uses synthesized keystrokes (not AXValue) because the field is a
-- React-controlled input that only updates on real key events.
local function fillOpenVpnPin(app)
  local pin = os.getenv('VPN_CONNECT_PIN')
  if not pin then
    hs.alert.show('VPN_CONNECT_PIN not set')
    return
  end

  local attempts = 0
  local function tryFill()
    attempts = attempts + 1
    local ax = hs.axuielement.applicationElement(app)
    local win = nil
    for _, w in ipairs(ax:attributeValue('AXWindows') or {}) do
      if w:attributeValue('AXTitle') == 'OpenVPN Connect' then
        win = w
        break
      end
    end
    win = win or ax

    local field = findAxElement(win, function(el)
      return el:attributeValue('AXRole') == 'AXTextField' and el:attributeValue('AXTitle') == 'Pin'
    end)

    if not field then
      if attempts < 20 then
        hs.timer.doAfter(0.2, tryFill)
      else
        hs.alert.show('OpenVPN pin field not found')
      end
      return
    end

    field:setAttributeValue('AXFocused', true)

    hs.timer.doAfter(0.1, function()
      hs.eventtap.keyStrokes(pin)

      hs.timer.doAfter(0.15, function()
        local okButton = findAxElement(win, function(el)
          return el:attributeValue('AXRole') == 'AXGroup' and el:attributeValue('AXDescription') == 'OK'
        end)
        if okButton then
          okButton:performAction('AXPress')
        else
          hs.eventtap.keyStroke({}, 'return')
        end
      end)
    end)
  end

  tryFill()
end

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
        fillOpenVpnPin(app)
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

#!/bin/bash
# ws="${AEROSPACE_FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
# if aerospace list-windows --workspace "$ws" --format '%{window-is-fullscreen}' 2>/dev/null | grep -qx true; then
# 	osascript -e 'tell application "System Events" to set autohide of dock preferences to true'
# else
# 	osascript -e 'tell application "System Events" to set autohide of dock preferences to false'
# fi

# V2 with state
# LOCKDIR="/tmp/aerospace-dock.lock"
# STATE="/tmp/aerospace-dock.state"

# # Serialize: only one toggle at a time
# for _ in $(seq 1 50); do
# 	mkdir "$LOCKDIR" 2>/dev/null && break
# 	sleep 0.02
# done
# trap 'rmdir "$LOCKDIR" 2>/dev/null' EXIT

# # Re-read the ACTUAL focused workspace — the event var can be stale after fast switches
# ws="$(aerospace list-workspaces --focused 2>/dev/null)"
# if aerospace list-windows --workspace "$ws" --format '%{window-is-fullscreen}' 2>/dev/null | grep -qx true; then
# 	want=true
# else
# 	want=false
# fi

# # Skip the slow, race-prone osascript if the dock is already where we want it
# [ "$(cat "$STATE" 2>/dev/null)" = "$want" ] && exit 0
# printf '%s' "$want" >"$STATE"
# osascript -e "tell application \"System Events\" to set autohide of dock preferences to $want"

# V3
w="$(aerospace list-windows --focused --format '%{window-id}' 2>/dev/null)"
if [ -n "$w" ] && aerospace list-windows --focused --format '%{window-is-fullscreen}' | grep -qx true; then
	osascript -e 'tell application "System Events" to set autohide of dock preferences to true'
	aerospace fullscreen off --window-id "$w" 2>/dev/null
	aerospace fullscreen on --no-outer-gaps --window-id "$w" 2>/dev/null
else
	osascript -e 'tell application "System Events" to set autohide of dock preferences to false'
fi

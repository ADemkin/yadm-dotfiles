#!/bin/sh
set -e

selected=$("$PACKAGE_DIR/scripts/duration.sh")
if [ "$1" = duration ]; then
  selected=$(printf '%.0f' "$VALUE")
  printf '%s %s\n' "$DURATION" "$selected" > "$CONFIG_DIR/amphetamine-duration"
fi

osascript - "$1" "$selected" "$DISPLAY_SLEEP" <<'APPLESCRIPT'
on run argv
  tell application "Amphetamine"
    set action to item 1 of argv
    set activeSession to session is active
    if action is "duration" and not activeSession then return
    if action is "stop" or (action is "toggle" and activeSession) then
      end session
    else
      set sessionDuration to item 2 of argv as integer
      set sessionInterval to minutes
      if action is "indefinitely" or sessionDuration is 0 then
        set sessionDuration to 0
        set sessionInterval to 0
      end if
      set sleepAllowed to item 3 of argv is "allow"
      start new session with options {duration:sessionDuration, interval:sessionInterval, displaySleepAllowed:sleepAllowed}
    end if
  end tell
end run
APPLESCRIPT

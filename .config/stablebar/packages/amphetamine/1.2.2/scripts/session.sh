#!/bin/sh
set -e

duration=$("$PACKAGE_DIR/scripts/duration.sh")

remaining=-3
if [ "$(osascript -e 'application "Amphetamine" is running')" = true ]; then
  remaining=$(osascript -e 'tell application "Amphetamine" to session time remaining')
fi
icon=pill.fill
case $remaining in
  -3) text=Off; icon=pill; status="No active session" ;;
  -2) text=Awake; status="Keeping awake for an app or until a set time" ;;
  -1) text=Awake; status="Keeping awake with a trigger" ;;
  0) text=Awake; status="Keeping awake indefinitely" ;;
  *)
    minutes=$(((remaining + 59) / 60))
    text="${minutes}m"
    status="$minutes min remaining"
    ;;
esac

# The slider's end stop past 240 sends 0: keep awake indefinitely.
if [ "$duration" = 0 ]; then
  durationLabel="∞"; timedLabel="Keep awake indefinitely"; timedIcon=infinity
else
  durationLabel="${duration}m"; timedLabel="Keep awake for $duration min"; timedIcon=timer
fi

[ "$BAR_DISPLAY" = icon ] && text=""
action=""
if [ "$CLICK_ACTION" = toggle ]; then
  action=",\"onClick\":\"\\\"\$PACKAGE_DIR/scripts/control.sh\\\" toggle\""
fi
printf '{"text":"%s","icon":"%s","values":{"duration":%s},"fields":{"status":"%s","timedLabel":"%s","timedIcon":"%s","durationLabel":"%s"}%s}\n' \
  "$text" "$icon" "$duration" "$status" "$timedLabel" "$timedIcon" "$durationLabel" "$action"

#!/bin/sh

selected=$DURATION
if [ -f "$CONFIG_DIR/amphetamine-duration" ]; then
  read -r savedDefault selectedDuration < "$CONFIG_DIR/amphetamine-duration"
  [ "$savedDefault" != "$DURATION" ] || selected=$selectedDuration
fi
printf '%s\n' "$selected"

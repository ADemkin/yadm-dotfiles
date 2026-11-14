#!/bin/sh
# Usage: control.sh playpause | "next track" | "previous track" | back | forward | quieter | louder
#                   | shuffle | repeat | favorite
# back and forward skip 15 seconds; quieter and louder change the player's volume by 10.
set -e

# Control the playing player, else the paused one. With only one player open, skip asking
# for its state, so the click reaches it sooner.
open=""
for app in Music Spotify; do
  if pgrep -xq "$app"; then open="$open $app"; fi
done
target=""
for app in $open; do
  if [ "$open" = " $app" ]; then target=$app; break; fi
  case $(osascript -e "tell application \"$app\" to player state as text") in
    playing) target=$app; break ;;
    paused) [ -n "$target" ] || target=$app ;;
  esac
done
[ -n "$target" ] || exit 0

case $1 in
  playpause | "next track" | "previous track") command=$1 ;;
  back) command="set player position to (player position - 15)" ;;
  forward) command="set player position to (player position + 15)" ;;
  # Spotify stores a volume one lower than it was given, so step from the nearest ten.
  quieter) command="set v to ((sound volume + 5) div 10 - 1) * 10
if v < 0 then set v to 0
set sound volume to v" ;;
  louder) command="set v to ((sound volume + 5) div 10 + 1) * 10
if v > 100 then set v to 100
set sound volume to v" ;;
  shuffle)
    if [ "$target" = Music ]; then
      command="set shuffle enabled to not shuffle enabled"
    else
      command="set shuffling to not shuffling"
    fi
    ;;
  repeat)
    if [ "$target" = Music ]; then
      command="if song repeat is off then
  set song repeat to all
else if song repeat is all then
  set song repeat to one
else
  set song repeat to off
end if"
    else
      command="set repeating to not repeating"
    fi
    ;;
  favorite)
    [ "$target" = Music ] || exit 0
    command="set favorited of current track to not (favorited of current track)"
    ;;
  *) echo "Unknown action: $1" >&2; exit 1 ;;
esac

osascript -e "tell application \"$target\"" -e "$command" -e "end tell"

#!/bin/sh

case "$1" in
--safari)
  defaultbrowser safari
  ;;
--arc)
  defaultbrowser browser
  ;;
"")
  defaultbrowser
  ;;
*)
  echo "Usage: $(basename "$0") [--safari|--arc]"
  exit 1
  ;;
esac

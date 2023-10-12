#!/bin/sh -e

host="ya.ru"
count=5

ping_result="$(ping -c "$count" "$host" 2>/dev/null | tail -1)"
# echo $ping_result >> debug-ping.log
ping_ms="$(echo $ping_result | cut -d "=" -f2 | cut -d "/" -f2 | xargs | cut -d "." -f1)"
# echo $ping_ms >> debug-ping.log
if [ -z $ping_ms ]; then
    echo "offline"
else
    echo "$ping_ms ms"
fi

#!/bin/sh -e

host="ya.ru"
count=1

ping_result="$(ping -c "$count" "$host" 2>/dev/null | tail -1)"
ping_ms="$(echo $ping_result | cut -d "=" -f2 | cut -d "/" -f2 | xargs | cut -d "." -f1)"
if [ -z $ping_ms ]; then
    echo "offline"
else
    echo "$ping_ms ms"
fi

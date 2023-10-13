#!/bin/sh -e

main() {
    local ping_host="ya.ru"
    local ping_count=5

    get_ping() {
        local ping_result="$(ping -c "$ping_count" "$ping_host" 2>/dev/null | tail -1)"
        # echo "result: $ping_result" >> debug-ping.log
        if [ -n "$(grep -o '0 packets received')" ]; then
            echo "lost"
        else
            local ping_ms="$(echo $ping_result | grep -oE "\d{2}\.\d{3}" | sed -n "2p" | cut -d"." -f1)"
            # echo "ms: $ping_ms" >> debug-ping.log
            if [ -z $ping_ms ]; then
                echo "offline"
            else
                echo "$ping_ms ms"
            fi
        fi
    }
    get_ping
}
main

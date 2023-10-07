#!/bin/sh

# inspired by 'tmux-plugins/tmux-online-status'

ping_host="www.ya.ru"
timeout=1
status_online='online'
status_offline='offline 💥'

is_network_ok() {
    ping -c 1 -t "$timeout" "$ping_host" 1>/dev/null 2>&1
}

get_status() {
    if $(is_network_ok); then
        echo $status_online
    else
        echo $status_offline
    fi
}

get_status

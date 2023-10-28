#!/bin/sh
#
# inspired by tmux-network-brandwidth plugin


get_bandwidth_for_macos() {
  netstat -ibn | awk 'FNR > 1 {
    interfaces[$1 ":bytesReceived"] = $(NF-4);
    interfaces[$1 ":bytesSent"]     = $(NF-1);
  } END {
    for (itemKey in interfaces) {
      split(itemKey, keys, ":");
      interface = keys[1]
      dataKind = keys[2]
      sum[dataKind] += interfaces[itemKey]
    }

    print sum["bytesReceived"], sum["bytesSent"]
  }'
}

format_speed() {
    local padding=7
    numfmt --to=iec-i --suffix "B/s" --format "%f" --padding=$padding $1
}

main() {
    local sleep_time=5
    local first_measure=( $(get_bandwidth_for_macos) )
    sleep $sleep_time
    local second_measure=( $(get_bandwidth_for_macos) )
    local download_speed=$(((${second_measure[0]} - ${first_measure[0]}) / $sleep_time))
    local upload_speed=$(((${second_measure[1]} - ${first_measure[1]}) / $sleep_time))
    echo "↓$(format_speed $download_speed) ↑$(format_speed $upload_speed)"
}


main

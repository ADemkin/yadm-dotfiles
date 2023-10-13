#!/bin/sh -e

main() {
    local battery_status="$(pmset -g batt)"
    local battery_percentage="$(echo $battery_status | grep -o '\d*%')"

    local status_calculatin="calculating"
    local status_charged="charged"
    local status_charging="charging"

    if [ -z "$battery_percentage" ]; then  # length is zero
        echo "AC"
    else
        if [ -n "$(echo $battery_status | grep -o 'discharging')" ]; then  # length is nonzero
            if [ -n "$(echo $battery_status | grep -o '(no estimate)')" ]; then
                # not yet calculated remaining time
                echo "$battery_percentage $status_calculating"
            else
                # remaining time calculated
                echo $battery_percentage "$(echo $battery_status | grep -oE '\d+:\d+')"
            fi
        else
            if [ "$battery_percentage" = "100%" ]; then
                echo "$battery_percentage $status_charged"
            else
                # WTF?
                # not yet switched to charging?
                echo "$battery_percentage $status_charging"
            fi
        fi
    fi
}
main

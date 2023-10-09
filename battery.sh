#!/bin/sh -e

BATT="$(pmset -g batt)"
PERCENTAGE="$(echo $BATT | grep -o '\d*%')"

if [ -z "$PERCENTAGE" ]; then  # length is zero
    echo "AC"
else
    if [ -n "$(echo $BATT | grep -o 'discharging')" ]; then  # length is nonzero
        if [ -n "$(echo $BATT | grep -o '(no estimate)')" ]; then
            # not yet calculated remaining time
            echo $PERCENTAGE "calculating"
        else
            # remaining time calculated
            echo $PERCENTAGE "$(echo $BATT | grep -oE '\d+:\d+')"
        fi
    else
        if [ "$PERCENTAGE" = "100%" ]; then
            echo $PERCENTAGE "charged"
        else
            # WTF?
            # not yet switched to charging?
            echo $PERCENTAGE "charging"
        fi
    fi
fi

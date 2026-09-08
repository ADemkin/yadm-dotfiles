#!/bin/sh

sudo killall -HUP mDNSResponder
sudo networksetup -setdnsservers Wi-Fi 8.8.8.8 1.1.1.1

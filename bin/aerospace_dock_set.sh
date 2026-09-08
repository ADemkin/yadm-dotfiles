#!/bin/sh

defaults write com.apple.dock autohide-delay -float 0.3
defaults write com.apple.dock autohide-time-modifier -float 0
killall Dock

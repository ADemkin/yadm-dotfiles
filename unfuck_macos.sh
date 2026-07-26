#!/bin/sh

echo "Update macOS settings"

echo "text edit open empty file by default"
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false

echo "remove stupid delay and popup on language switch"
defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 2

echo "disable dock hide animation"
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
killall Dock

echo "disable window open animations"
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

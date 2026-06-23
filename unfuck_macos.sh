#!/bin/sh

echo "Update macOS settings"

echo "text edit open empty file by default"
defaults write com.apple.TextEdit NSShowAppCentricOpenPanelInsteadOfUntitledFile -bool false

echo "remove stupid delay and popup on language switch"
defaults write kCFPreferencesAnyApplication TSMLanguageIndicatorEnabled 2

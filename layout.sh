#!/bin/sh

LANGUAGENAME=$(defaults read ~/Library/Preferences/com.apple.HIToolbox AppleInputSourceHistory |
    grep "KeyboardLayout Name" |
    head -1 |
    cut -d " " -f 12 |
    cut -c 1-3)
case $LANGUAGENAME in
    ABC)
        # echo "🇬🇧"
        # LANG="🇺🇸 "
        LANG="ABC"
        ;;
    Rus)
        # LANG="🇷🇺 "
        LANG="RU"
        ;;
    *)
        LANG=$LANGUAGENAME
        ;;
esac
echo "$LANG"

#!/bin/sh

file=`mktemp`.sh
tmux capture-pane -pS -32768 > $file
tmux new-window -nvim "$EDITOR '+ normal G $' $file"

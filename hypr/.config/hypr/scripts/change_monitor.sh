#!/bin/bash
# ~/.config/hypr/scripts/change_monitor.sh
# Moves the active window to the "equivalent" workspace on the other monitor.
# Does nothing if only one monitor is connected.

# Do nothing if only one monitor is connected
MONITOR_COUNT=$(hyprctl monitors -j | jq 'length')
if [ "$MONITOR_COUNT" -lt 2 ]; then
    exit 0
fi

# Get the current workspace index of the active window
CURRENT_WS=$(hyprctl activewindow -j | jq '.workspace.id')

if [ "$CURRENT_WS" -le 9 ]; then
    TARGET=$((CURRENT_WS + 10))
else
    TARGET=$((CURRENT_WS - 10))
fi

hyprctl dispatch movetoworkspace $TARGET

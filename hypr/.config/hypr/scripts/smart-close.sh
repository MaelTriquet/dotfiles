#!/bin/bash

STORE="/tmp/hypr_last_closed"

# Get current active window FIRST
ADDR=$(hyprctl activewindow -j | jq -r '.address')

# If no active window, do nothing
[ -z "$ADDR" ] && exit 0
[ "$ADDR" = "null" ] && exit 0

# If something is already stored, kill it permanently
if [ -f "$STORE" ]; then
    OLD_ADDR=$(cat "$STORE")
    if [ -n "$OLD_ADDR" ]; then
        hyprctl dispatch killwindow address:$OLD_ADDR 2>/dev/null
    fi
    rm -f "$STORE"
fi

# Move current window to hidden graveyard workspace
hyprctl dispatch movetoworkspacesilent special:graveyard,address:$ADDR

# Store its address
echo "$ADDR" > "$STORE"

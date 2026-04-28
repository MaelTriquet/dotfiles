#!/bin/bash

launch_on_workspace() {
    local workspace=$1
    local command=$2

    hyprctl dispatch workspace "$workspace" > /dev/null
    hyprctl dispatch exec "$command" > /dev/null
    sleep 0.5  # Small delay to let the app open
}

terminal="uwsm app -- kitty"

# # --- Workspace 1: Browser ---
# launch_on_workspace 1 omarchy-launch-browser

# --- Workspace 1: Browser ---
launch_on_workspace 1 "omarchy-launch-browser"

# --- Workspace 3: AI Assistant ---
launch_on_workspace 3 "omarchy-launch-webapp https://claude.ai"
sleep 2

# --- Workspace 4: Email Client ---
launch_on_workspace 4 "$terminal -- aerc"

# --- Workspace 5: Btop ---
launch_on_workspace 5 "$terminal -- btop"

# --- Workspace 9: Music Player ---
launch_on_workspace 9 "omarchy-launch-webapp https://spotify.com"
sleep 2

# --- Workspace 2: Terminal ---
launch_on_workspace 2 "$terminal -- nvim -c term -c startinsert"

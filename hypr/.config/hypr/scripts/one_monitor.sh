#!/bin/bash

for n in $(seq 11 20); do
    target=$((n - 10))
    # Get all window addresses on workspace $n
    addresses=$(hyprctl clients -j | jq -r --argjson ws "$n" '.[] | select(.workspace.id == $ws) | .address')
    
    for addr in $addresses; do
        hyprctl dispatch movetoworkspacesilent "${target},address:${addr}"
    done
done

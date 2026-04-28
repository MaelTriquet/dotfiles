#!/bin/bash

INDEX=$1  # 0-9, the key you pressed

if [ $INDEX = "10" ]; then
	INDEX=20
fi

if [ $INDEX = "0" ]; then
	INDEX=10
fi



echo $INDEX
# Get the focused monitor name
MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

if [ "$MONITOR" = "eDP-1" ]; then
    TARGET=$INDEX
else
    TARGET=$((INDEX + 10))
fi

hyprctl dispatch workspace $TARGET

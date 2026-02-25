#!/bin/bash

STORE="/tmp/hypr_last_closed"

[ ! -f "$STORE" ] && exit 0

ADDR=$(cat "$STORE")

[ -z "$ADDR" ] && exit 0

hyprctl dispatch movetoworkspace +0,address:$ADDR

rm -f "$STORE"

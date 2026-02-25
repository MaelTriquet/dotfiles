STORE="/tmp/hypr_last_closed"

if [ -f "$STORE" ]; then
    OLD_ADDR=$(cat "$STORE")
    if [ -n "$OLD_ADDR" ]; then
        hyprctl dispatch killwindow address:$OLD_ADDR 2>/dev/null
    fi
    rm -f "$STORE"
fi


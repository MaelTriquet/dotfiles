#!/usr/bin/env bash
set -euo pipefail

echo "=== Kanata automatic setup ==="

# ----------- Helper functions -------------
err() { echo "ERROR: $*" >&2; exit 1; }
ok()  { echo "[OK] $*"; }

# ----------- Check dependencies -----------
if ! command -v systemctl >/dev/null; then
  err "systemd not found. This script requires systemd."
fi

# ----------- Install kanata if missing ----
if ! command -v kanata >/dev/null; then
  echo "Kanata not detected. Installing..."

  sudo pacman -S --needed kanata || err "Failed to install kanata"

  ok "Kanata installed"
else
  ok "Kanata already installed"
fi

# ----------- Install config ----------------
KANATA_DIR="$HOME/.config/kanata"
mkdir -p "$KANATA_DIR"

if [[ ! -d ./kanata ]]; then
  err "No './kanata' directory found next to this script. Put your config folder next to this script."
fi

echo "Copying config files..."
cp -r ./kanata/* "$KANATA_DIR"/
ok "Config installed to $KANATA_DIR"

# ----------- Create systemd service --------
SERVICE_FILE="$HOME/.config/systemd/user/kanata.service"
mkdir -p "$(dirname "$SERVICE_FILE")"

cat > "$SERVICE_FILE" <<EOF
[Unit]
Description=Kanata Keyboard Remapper
After=graphical-session-pre.target

[Service]
ExecStart=/usr/bin/kanata --config $KANATA_DIR/kanata.kbd
Restart=always
RestartSec=2

[Install]
WantedBy=default.target
EOF

ok "Systemd user service created"

# ----------- Enable service ----------------
systemctl --user daemon-reload
systemctl --user enable --now kanata.service

ok "Kanata systemd service enabled and started"

# ----------- Check status ------------------
echo "Checking service status..."
systemctl --user status kanata.service --no-pager || true

echo "=== Kanata setup complete ==="
echo "If you are not using lingering, run:"
echo "  loginctl enable-linger \$USER"
echo "to allow user services to run at boot."

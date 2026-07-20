#!/bin/bash

set -eu

if ! grep -qiE '(microsoft|wsl)' /proc/sys/kernel/osrelease 2>/dev/null; then
    exit 0
fi

mkdir -p /etc/systemd/system/ModemManager.service.d

cat > /etc/systemd/system/ModemManager.service.d/override.conf <<'EOF'
[Unit]
ConditionVirtualization=
EOF

cat > /etc/asound.conf <<'EOF'
pcm.!default {
    type null
}

ctl.!default {
    type null
}
EOF

echo emulator > /etc/hostname

cat > /etc/hosts <<'EOF'
127.0.0.1 localhost
127.0.1.1 emulator
EOF

systemctl daemon-reload
systemctl restart ModemManager.service || true
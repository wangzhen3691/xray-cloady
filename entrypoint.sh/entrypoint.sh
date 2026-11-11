#!/bin/sh
set -e
if [ -z "$UUID" ]; then echo "UUID env var is required" >&2; exit 1; fi
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "info" },
  "inbounds": [
    {
      "port": 3000,
      "protocol": "vless",
      "settings": {
        "clients": [{ "id": "$UUID", "level": 0 }],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "/tk-rail" }
      }
    }
  ],
  "outbounds": [{ "protocol": "freedom", "tag": "direct" }]
}
EOF
exec /usr/local/bin/xray run -config /etc/xray/config.json

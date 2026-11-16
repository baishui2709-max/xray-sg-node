#!/bin/sh
set -e
PORT="${PORT:-10000}"
: "${UUID:?UUID env var is required}"
WS_PATH="${WS_PATH:-/v1}"
mkdir -p /usr/local/etc/xray
cat > /usr/local/etc/xray/config.json <<EOC
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "${UUID}" } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "${WS_PATH}" }
      },
      "sniffing": { "enabled": true, "destOverride": ["http", "tls"] }
    }
  ],
  "outbounds": [ { "protocol": "freedom", "tag": "direct" } ]
}
EOC
exec /usr/local/bin/xray run -config /usr/local/etc/xray/config.json

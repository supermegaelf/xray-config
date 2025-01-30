#!/bin/bash

cat > "/var/lib/marzban/xray_config.json" <<EOF
{
  "log": {
    "access": "/var/lib/marzban/access.log",
    "error": "/var/lib/marzban/error.log",
    "loglevel": "warning",
    "dnsLog": true
  },
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "ip": ["geoip:private"],
        "outboundTag": "BLOCK",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "IPv4",
        "domain": ["geosite:google"]
      },
      {
        "protocol": ["bittorrent"],
        "outboundTag": "BLOCK",
        "type": "field"
      }
    ]
  },
  "inbounds": [
    {
      "tag": "Shadowsocks TCP",
      "listen": "0.0.0.0",
      "port": 1080,
      "protocol": "shadowsocks",
      "settings": {
        "clients": [],
        "network": "tcp,udp"
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "DIRECT"
    },
    {
      "protocol": "blackhole",
      "tag": "BLOCK"
    },
    {
      "tag": "IPv4",
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "ForceIPv4"
      }
    }
  ]
}
EOF

marzban restart

#!/usr/bin/env bash
# Configure static IP on Ubuntu (SIEM or Target) - LAB helper
# Usage: sudo ./configure_ubuntu_static_ip.sh 192.168.56.10 soc-siem

set -euo pipefail

IP="${1:?Usage: $0 <ip> <hostname> [iface]}"
HOST="${2:?hostname required}"
IFACE="${3:-}"

if [[ -z "${IFACE}" ]]; then
  IFACE="$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo | head -1)"
fi

hostnamectl set-hostname "${HOST}"

cat > /etc/netplan/99-soc-lab.yaml <<EOF
network:
  version: 2
  ethernets:
    ${IFACE}:
      addresses: [${IP}/24]
      routes:
        - to: default
          via: 192.168.56.1
      nameservers:
        addresses: [8.8.8.8, 1.1.1.1]
EOF

netplan apply
echo "[+] ${HOST} configured with ${IP} on ${IFACE}"
ip -4 addr show "${IFACE}"

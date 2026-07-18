#!/usr/bin/env bash
# Prepare Ubuntu target: SSH, nginx, weak user (LAB ONLY)
# Usage: sudo ./setup_target_services.sh

set -euo pipefail

apt update
apt install -y openssh-server nginx auditd
systemctl enable --now ssh nginx

if ! id targetuser >/dev/null 2>&1; then
  adduser --gecos "Lab Target User" --disabled-password targetuser
  echo "targetuser:password123" | chpasswd
  echo "[+] Created targetuser / password123"
else
  echo "[=] targetuser already exists"
fi

# Simple landing page for Invoke-WebRequest demos
cat > /var/www/html/index.html <<'HTML'
<!DOCTYPE html>
<html><head><title>SOC Lab Target</title></head>
<body>
<h1>SOC Analyst Lab - Target Server</h1>
<p>Host: soc-target | Role: intentional vulnerable services for training.</p>
</body></html>
HTML

echo "[+] Target services ready. SSH :22 HTTP :80"

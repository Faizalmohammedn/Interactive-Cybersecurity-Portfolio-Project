#!/usr/bin/env bash
# Attack 2: Port / service scan with Nmap (LAB ONLY)
# Usage: ./02_port_scan.sh [target_ip]

set -euo pipefail

TARGET="${1:-192.168.56.40}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTDIR="${SCRIPT_DIR}/../../Reports/raw"
mkdir -p "${OUTDIR}"
STAMP="$(date +%Y%m%d-%H%M%S)"
BASE="${OUTDIR}/nmap-${TARGET}-${STAMP}"

if ! command -v nmap >/dev/null 2>&1; then
  echo "[!] nmap not found"
  exit 1
fi

echo "[*] Host discovery ping..."
nmap -sn "${TARGET}" || true

echo "[*] TCP SYN scan + version detect on ${TARGET}..."
nmap -sS -sV -sC --top-ports 1000 -T4 "${TARGET}" -oA "${BASE}-top"

echo "[*] Optional full port sweep (slower)..."
read -r -p "Run full -p- scan? [y/N] " ans || true
if [[ "${ans:-N}" =~ ^[Yy]$ ]]; then
  nmap -sS -p- -T4 --min-rate 300 "${TARGET}" -oA "${BASE}-full"
fi

echo "[+] Outputs: ${BASE}-*"
echo "[*] Correlate with Sysmon EID 3 / Wireshark SYN spikes."

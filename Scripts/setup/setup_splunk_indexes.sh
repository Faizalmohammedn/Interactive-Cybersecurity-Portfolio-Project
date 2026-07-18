#!/usr/bin/env bash
# Post-install Splunk helper: enable listen + create indexes (LAB)
# Usage: sudo ./setup_splunk_indexes.sh admin 'YourPassword'

set -euo pipefail

USER="${1:-admin}"
PASS="${2:?password required}"
SPLUNK="${SPLUNK_HOME:-/opt/splunk}/bin/splunk"

if [[ ! -x "${SPLUNK}" ]]; then
  echo "[!] Splunk not found at ${SPLUNK}"
  exit 1
fi

"${SPLUNK}" enable listen 9997 -auth "${USER}:${PASS}" || true

for idx in windows sysmon linux network; do
  "${SPLUNK}" add index "${idx}" -auth "${USER}:${PASS}" 2>/dev/null || echo "[=] index ${idx} may already exist"
done

echo "[+] Indexes ensured. Receiving on 9997."

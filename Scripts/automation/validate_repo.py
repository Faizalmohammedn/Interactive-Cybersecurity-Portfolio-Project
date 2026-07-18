#!/usr/bin/env python3
"""
Validate that key lab artifacts exist (docs, rules, scripts).
Usage: python validate_repo.py
"""

from __future__ import annotations

import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]

REQUIRED = [
    "README.md",
    "Architecture/README.md",
    "Documentation/01-Lab-Setup.md",
    "Documentation/02-Splunk-Install.md",
    "Documentation/03-Sysmon-Setup.md",
    "Documentation/04-Attack-Simulations.md",
    "Splunk/searches/core_searches.spl",
    "Sigma/proc_powershell_encoded.yml",
    "YARA/suspicious_exfil_staging.yar",
    "Scripts/attacks/01_brute_force_ssh.sh",
    "Scripts/attacks/03_suspicious_powershell.ps1",
    "Reports/Lessons-Learned.md",
]


def main() -> int:
    missing = [p for p in REQUIRED if not (ROOT / p).exists()]
    if missing:
        print("[!] Missing required files:")
        for m in missing:
            print("   -", m)
        return 1
    print(f"[+] Repo OK — {len(REQUIRED)} required paths present under {ROOT}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

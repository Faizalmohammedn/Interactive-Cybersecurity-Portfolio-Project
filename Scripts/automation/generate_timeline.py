#!/usr/bin/env python3
"""
Generate a simple lab timeline / IOC summary from attack metadata.
Usage: python generate_timeline.py
"""

from __future__ import annotations

import json
from datetime import datetime, timedelta, timezone
from pathlib import Path

OUT = Path(__file__).resolve().parents[2] / "Reports" / "raw"
OUT.mkdir(parents=True, exist_ok=True)

NOW = datetime.now(timezone.utc)


def main() -> None:
    events = [
        {
            "time": (NOW - timedelta(minutes=40)).isoformat(),
            "host": "soc-attacker",
            "action": "Nmap SYN scan against soc-target",
            "mitre": "T1046",
            "src": "192.168.56.30",
            "dst": "192.168.56.40",
        },
        {
            "time": (NOW - timedelta(minutes=30)).isoformat(),
            "host": "soc-attacker",
            "action": "Hydra SSH brute force against targetuser",
            "mitre": "T1110",
            "src": "192.168.56.30",
            "dst": "192.168.56.40",
        },
        {
            "time": (NOW - timedelta(minutes=25)).isoformat(),
            "host": "soc-target",
            "action": "Successful SSH login after failures",
            "mitre": "T1078",
            "src": "192.168.56.30",
            "dst": "192.168.56.40",
        },
        {
            "time": (NOW - timedelta(minutes=15)).isoformat(),
            "host": "soc-victim",
            "action": "Encoded PowerShell execution",
            "mitre": "T1059.001",
            "src": "192.168.56.20",
            "dst": "n/a",
        },
        {
            "time": (NOW - timedelta(minutes=5)).isoformat(),
            "host": "soc-victim",
            "action": "Staged customer_export_fake.csv for exfil sim",
            "mitre": "T1074",
            "src": "192.168.56.20",
            "dst": "192.168.56.30",
        },
    ]

    iocs = {
        "ip_addresses": ["192.168.56.30"],
        "users": ["targetuser", "labuser"],
        "files": [
            "customer_export_fake.csv",
            "soc_lab_exfil_stage.txt",
            "staged_customer_export.csv",
        ],
        "commands": [
            "powershell -EncodedCommand",
            "hydra -l targetuser -P wordlist-lab.txt ssh://192.168.56.40",
            "nmap -sS -sV",
        ],
    }

    payload = {"generated_at": NOW.isoformat(), "timeline": events, "iocs": iocs}
    path = OUT / "lab_timeline.json"
    path.write_text(json.dumps(payload, indent=2), encoding="utf-8")

    md = OUT / "lab_timeline.md"
    lines = ["# Lab Attack Timeline (Generated)", ""]
    for e in events:
        lines.append(f"- **{e['time']}** — `{e['host']}` — {e['action']} ({e['mitre']})")
    lines += ["", "## IOCs", ""]
    for k, vals in iocs.items():
        lines.append(f"### {k}")
        for v in vals:
            lines.append(f"- `{v}`")
        lines.append("")
    md.write_text("\n".join(lines), encoding="utf-8")
    print(f"[+] Wrote {path}")
    print(f"[+] Wrote {md}")


if __name__ == "__main__":
    main()

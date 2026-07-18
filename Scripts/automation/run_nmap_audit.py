#!/usr/bin/env python3
"""
Run a structured Nmap audit and write markdown findings (LAB ONLY).
Requires: nmap installed and reachable targets.
Usage: python run_nmap_audit.py 192.168.56.40
"""

from __future__ import annotations

import argparse
import shutil
import subprocess
import sys
from datetime import datetime, timezone
from pathlib import Path


def run(cmd: list[str]) -> str:
    print("[*]", " ".join(cmd))
    proc = subprocess.run(cmd, capture_output=True, text=True, check=False)
    return (proc.stdout or "") + (proc.stderr or "")


def main() -> int:
    parser = argparse.ArgumentParser(description="SOC lab Nmap audit")
    parser.add_argument("target", nargs="?", default="192.168.56.40")
    parser.add_argument("--top-ports", type=int, default=100)
    args = parser.parse_args()

    if not shutil.which("nmap"):
        print("[!] nmap not found on PATH", file=sys.stderr)
        return 1

    out_dir = Path(__file__).resolve().parents[2] / "Reports" / "raw"
    out_dir.mkdir(parents=True, exist_ok=True)
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    raw = out_dir / f"nmap-audit-{args.target}-{stamp}.txt"
    md = out_dir / f"nmap-audit-{args.target}-{stamp}.md"

    output = run(
        [
            "nmap",
            "-sV",
            "-sC",
            "--top-ports",
            str(args.top_ports),
            "-T4",
            args.target,
        ]
    )
    raw.write_text(output, encoding="utf-8")

    open_hints = [
        line.strip()
        for line in output.splitlines()
        if "/tcp" in line and "open" in line
    ]

    md_lines = [
        f"# Nmap Audit — {args.target}",
        "",
        f"Generated: `{stamp}`",
        "",
        "## Open Ports (parsed)",
        "",
    ]
    if open_hints:
        for line in open_hints:
            md_lines.append(f"- `{line}`")
    else:
        md_lines.append("- No open ports parsed (host down or filtered).")

    md_lines += [
        "",
        "## Analyst Notes",
        "",
        "- Compare with baseline snapshot services.",
        "- Feed interesting ports into OpenVAS for deeper checks.",
        "- Correlate scan source IP in Splunk Sysmon EID 3.",
        "",
        "## Raw Output",
        "",
        "```",
        output.strip() or "(empty)",
        "```",
        "",
    ]
    md.write_text("\n".join(md_lines), encoding="utf-8")
    print(f"[+] {raw}")
    print(f"[+] {md}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

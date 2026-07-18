# Incident Report IR-002 — Network Port Scan

| Field | Value |
|-------|-------|
| **Incident ID** | IR-002 |
| **Severity** | Medium |
| **Status** | Closed (Lab) |
| **Date** | 2026-07-18 |
| **Analyst** | SOC Analyst Lab |
| **MITRE** | T1046 Network Service Discovery |

## Summary

Host `192.168.56.30` (Kali) scanned `192.168.56.20` and `192.168.56.40` with Nmap (`-sS -sV`). Sysmon and PCAP showed many SYN attempts across numerous ports.

## Timeline

| Time | Event |
|------|-------|
| T+0 | Top-ports SYN scan started |
| T+2m | Unique destination ports from source exceeded alert threshold (50+) |
| T+5m | Service version detection against open ports |
| T+8m | Analyst confirmed via Wireshark Conversations |

## Evidence

```spl
index=sysmon EventCode=3
| bin _time span=2m
| stats dc(DestinationPort) as ports by SourceIp
| where ports > 50
```

Wireshark filter: `ip.src == 192.168.56.30 && tcp.flags.syn == 1 && tcp.flags.ack == 0`

## Impact

Reconnaissance only; mapped open services for follow-on attacks.

## Response

- Documented open ports vs baseline  
- Hardened unnecessary listeners on victim/target  
- Kept scan results in `Reports/raw/`  

## Recommendations

- Network IDS / Splunk alert for port-scan patterns  
- Segment attacker VLANs in real environments  
- Minimize exposed services  

## Screenshots

`Screenshots/IR-002-nmap.png`, `Screenshots/IR-002-wireshark.png`

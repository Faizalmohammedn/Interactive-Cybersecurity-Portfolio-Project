# Incident Report IR-004 — Data Transfer / Exfiltration Simulation

| Field | Value |
|-------|-------|
| **Incident ID** | IR-004 |
| **Severity** | High |
| **Status** | Contained (Lab) |
| **Date** | 2026-07-18 |
| **Analyst** | SOC Analyst Lab |
| **MITRE** | T1074 Data Staged / T1048 Exfiltration Over Alternative Protocol (simulated) |

## Summary

A fake customer CSV (~2MB) was generated on the Windows victim under `Desktop\soc-lab-exfil` and staged in `%TEMP%`. Network connections toward Kali (`192.168.56.30`) were observed. YARA rule `suspicious_exfil_staging.yar` matched marker strings.

## Timeline

| Time | Event |
|------|-------|
| T+0 | `customer_export_fake.csv` created (Sysmon EID 11) |
| T+1m | Copy to `%TEMP%\staged_customer_export.csv` |
| T+2m | Outbound connection attempts to Kali |
| T+5m | Optional SCP/SMB pull from attacker |

## Evidence

```spl
index=sysmon EventCode=11
(TargetFilename="*soc-lab-exfil*" OR TargetFilename="*customer_export*")
| table _time, User, Image, TargetFilename
```

```spl
index=sysmon EventCode=3 DestinationIp="192.168.56.30"
| table _time, Image, DestinationPort, SourceIp
```

Wireshark: Follow TCP Stream for large payload transfers.

## Impact

Simulated data theft of fictitious PII. Demonstrates collection + exfil detection chain.

## Response

1. Deleted staging files  
2. Captured file hash for IOC list  
3. Blocked attacker IP on host firewall  
4. Documented detection gaps (need DLP / size-based alerts)  

## Recommendations

- Alert on sensitive filename patterns  
- Monitor large outbound transfers to rare destinations  
- Deploy YARA scanning on endpoints / sandboxes  

## Screenshots

`Screenshots/IR-004-filecreate.png`, `Screenshots/IR-004-pcap.png`

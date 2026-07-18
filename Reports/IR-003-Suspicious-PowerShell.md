# Incident Report IR-003 — Suspicious PowerShell

| Field | Value |
|-------|-------|
| **Incident ID** | IR-003 |
| **Severity** | High |
| **Status** | Contained (Lab) |
| **Date** | 2026-07-18 |
| **Analyst** | SOC Analyst Lab |
| **MITRE** | T1059.001 PowerShell / T1027 Obfuscated Files or Information |

## Summary

On `soc-victim`, PowerShell executed reconnaissance commands and an `-EncodedCommand` payload. Sysmon Event ID 1 captured parent/child process relationships and full command lines.

## Timeline

| Time | Event |
|------|-------|
| T+0 | `whoami` / `Get-NetIPAddress` style recon |
| T+1m | `Invoke-WebRequest` to `http://192.168.56.40/` |
| T+2m | Encoded PowerShell child process |
| T+3m | Staging marker file written under `%TEMP%` |

## Evidence

```spl
index=sysmon EventCode=1 Image="*\\powershell.exe*"
| table _time, User, ParentImage, CommandLine
```

```spl
index=sysmon EventCode=1 CommandLine="*EncodedCommand*" OR CommandLine="*-enc*"
```

YARA hit (optional): `suspicious_powershell_patterns.yar`

## Impact

Execution of obfuscated scripting on the endpoint; potential foothold behavior.

## Response

1. Identified encoded command content (base64 decode for IR notes)  
2. Reviewed parent process (Explorer vs Office vs scheduled task)  
3. Removed staging files  
4. Enabled Script Block Logging for future labs  

## Recommendations

- Alert on encoded PowerShell (Sigma rule included)  
- Constrain PowerShell with AppLocker / WDAC in real orgs  
- Enable Module / Script Block logging to Splunk  

## Screenshots

`Screenshots/IR-003-sysmon-powershell.png`

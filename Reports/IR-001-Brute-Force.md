# Incident Report IR-001 — SSH Password Brute Force

| Field | Value |
|-------|-------|
| **Incident ID** | IR-001 |
| **Severity** | High |
| **Status** | Contained (Lab) |
| **Date** | 2026-07-18 |
| **Analyst** | SOC Analyst Lab |
| **MITRE** | T1110 Brute Force / T1078 Valid Accounts |

## Summary

The Kali attacker (`192.168.56.30`) performed an SSH password spray/brute force against `soc-target` (`192.168.56.40`) using Hydra. Multiple authentication failures were followed by a successful login as `targetuser`.

## Timeline

| Time (UTC) | Event |
|------------|-------|
| T+0 | Hydra launched with `wordlist-lab.txt` |
| T+0–T+5m | Burst of `Failed password` entries in `/var/log/auth.log` |
| T+5m | `Accepted password for targetuser from 192.168.56.30` |
| T+6m | Analyst alerted via Splunk failed-login spike |
| T+10m | Attacker IP blocked with iptables; password reset |

## Evidence

**Splunk**

```spl
index=linux sourcetype=linux_secure ("Failed password" OR "Accepted password")
| rex field=_raw "from (?<src_ip>\d+\.\d+\.\d+\.\d+)"
| stats count by src_ip, user
```

**IOCs**

- Source IP: `192.168.56.30`
- Target: `192.168.56.40:22`
- Account: `targetuser`
- Tooling: Hydra

## Impact

Unauthorized access to the target server in the lab network. No production data.

## Response Actions

1. Confirmed true positive via auth.log + Splunk  
2. Contained: `iptables -A INPUT -s 192.168.56.30 -j DROP`  
3. Eradicated: reset `targetuser` password; reviewed `~/.bash_history`  
4. Recovered: services verified; snapshot optional  

## Recommendations

- Enforce SSH key authentication; disable password auth  
- Install fail2ban or equivalent  
- Alert on >10 failed SSH attempts / 5 minutes  
- Remove weak lab passwords outside training windows  

## Screenshots

Place evidence in `Screenshots/IR-001-*.png`.

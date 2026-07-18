# Step 5 — Monitor in Splunk

## Import Dashboards

1. Splunk Web → **Settings** → **User interface** → **Views**
2. Or create a simple app and copy XML from [`../Splunk/dashboards/`](../Splunk/dashboards/)

Dashboards included:

| File | Purpose |
|------|---------|
| `login_activity.xml` | Failed / successful logons |
| `suspicious_activity.xml` | PowerShell, new processes |
| `network_overview.xml` | Connections, top talkers |

## Core Searches

Copy from [`../Splunk/searches/`](../Splunk/searches/) into **Settings** → **Searches, reports, and alerts**.

### Login Activity

```spl
index=windows EventCode=4625
| eval src=coalesce(src_ip, Source_Network_Address)
| timechart span=5m count by Account_Name
```

```spl
index=windows EventCode=4624 Logon_Type=10 OR Logon_Type=3
| table _time, Account_Name, Source_Network_Address, Logon_Type
```

### Suspicious Activity

```spl
index=sysmon EventCode=1
(Image="*\\powershell.exe*" OR Image="*\\cmd.exe*" OR Image="*\\wscript.exe*")
| stats count by Image, User, ParentImage
```

```spl
index=sysmon EventCode=1 CommandLine="*-enc*" OR CommandLine="*-EncodedCommand*"
```

### Network Dashboard

```spl
index=sysmon EventCode=3
| stats count by SourceIp, DestinationIp, DestinationPort, Image
| sort -count
```

## Suggested Alerts

| Name | Condition | Severity |
|------|-----------|----------|
| Brute Force SSH | >15 failed SSH in 5m from one IP | High |
| Encoded PowerShell | Sysmon EID 1 with `-enc` | High |
| Port Scan Pattern | >50 unique dest ports from one IP in 2m | Medium |
| Large Outbound | Sysmon EID 3 to Kali IP + large file create | Medium |

Next: [06-Wireshark-Analysis.md](06-Wireshark-Analysis.md)

# Step 3 — Sysmon + Splunk Universal Forwarder (Windows Victim)

## Install Sysmon

1. Download [Sysinternals Sysmon](https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon)
2. Download a solid config (recommended: SwiftOnSecurity or Olaf Hartong modular)

```powershell
# Run as Administrator
Expand-Archive .\Sysmon.zip -DestinationPath C:\Tools\Sysmon
cd C:\Tools\Sysmon
.\Sysmon64.exe -accepteula -i .\sysmonconfig.xml
Get-Service Sysmon64
```

A starter config is included: [`../Scripts/setup/sysmonconfig-lab.xml`](../Scripts/setup/sysmonconfig-lab.xml)

## Key Event IDs for This Lab

| Event ID | Meaning |
|----------|---------|
| 1 | Process Create |
| 3 | Network Connection |
| 7 | Image Loaded (DLL) |
| 10 | Process Access |
| 11 | File Create |
| 13 | Registry Value Set |
| 22 | DNS Query |

## Install Splunk Universal Forwarder

1. Download UF for Windows
2. Install; point deployment server optional — leave blank
3. Receiving indexer: `192.168.56.10:9997`
4. Admin credentials for local UF management

## Configure Inputs

Copy lab inputs (see [`../Splunk/inputs/inputs.conf`](../Splunk/inputs/inputs.conf)) to:

```
C:\Program Files\SplunkUniversalForwarder\etc\system\local\inputs.conf
```

Example:

```ini
[WinEventLog://Security]
disabled = 0
index = windows

[WinEventLog://System]
disabled = 0
index = windows

[WinEventLog://Microsoft-Windows-Sysmon/Operational]
disabled = 0
index = sysmon
```

Restart UF:

```powershell
Restart-Service SplunkForwarder
```

## Verify in Splunk

```spl
index=sysmon OR index=windows
| head 20
```

If empty: check UF connectivity (`Test-NetConnection 192.168.56.10 -Port 9997`) and receiving on SIEM.

## Optional: Linux Target Forwarding

On target Ubuntu, install UF or use `rsyslog` → Splunk TCP input. Auth logs help detect SSH brute force.

```bash
# Minimal: monitor auth.log via UF monitor stanza
[monitor:///var/log/auth.log]
index = linux
sourcetype = linux_secure
```

Next: [04-Attack-Simulations.md](04-Attack-Simulations.md)

# Setup Scripts

| Script | Run on | Purpose |
|--------|--------|---------|
| `configure_ubuntu_static_ip.sh` | SIEM / Target | Hostname + netplan static IP |
| `setup_target_services.sh` | Target | SSH, nginx, weak `targetuser` |
| `setup_splunk_indexes.sh` | SIEM | Indexes + listen 9997 |
| `sysmonconfig-lab.xml` | Victim | Sysmon include rules for lab demos |

## Sysmon install (Windows Admin)

```powershell
Sysmon64.exe -accepteula -i sysmonconfig-lab.xml
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 5
```

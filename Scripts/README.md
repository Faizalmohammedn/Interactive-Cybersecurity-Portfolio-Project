# Scripts

| Folder | Purpose |
|--------|---------|
| `setup/` | Static IP, Splunk indexes, Sysmon config, target services |
| `attacks/` | Hydra, Nmap, PowerShell, exfil simulations |
| `automation/` | Timeline generator, Nmap audit, repo validator |

## Typical Lab Day

```bash
# On SIEM / Target (Ubuntu)
sudo bash Scripts/setup/configure_ubuntu_static_ip.sh 192.168.56.40 soc-target
sudo bash Scripts/setup/setup_target_services.sh

# On Kali
bash Scripts/attacks/02_port_scan.sh 192.168.56.40
bash Scripts/attacks/01_brute_force_ssh.sh 192.168.56.40 targetuser

# On Windows (Admin PowerShell for Sysmon; user for attacks)
# Sysmon64.exe -i Scripts\setup\sysmonconfig-lab.xml
powershell -ExecutionPolicy Bypass -File Scripts\attacks\03_suspicious_powershell.ps1
powershell -ExecutionPolicy Bypass -File Scripts\attacks\04_data_transfer.ps1

# Anywhere with Python
python Scripts/automation/validate_repo.py
python Scripts/automation/generate_timeline.py
```

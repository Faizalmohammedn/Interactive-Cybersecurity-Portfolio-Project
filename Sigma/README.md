# Sigma Detection Rules (SOC Analyst Lab)

| File | Detects | MITRE |
|------|---------|-------|
| `proc_powershell_encoded.yml` | Encoded PowerShell | T1059.001 / T1027 |
| `linux_ssh_bruteforce.yml` | SSH brute force | T1110 |
| `net_port_scan_sysmon.yml` | Port scan pattern | T1046 |
| `file_exfil_staging.yml` | Exfil staging files | T1074 |
| `win_failed_logons.yml` | Windows failed logons | T1110 |

## Convert to Splunk

```bash
pip install sigma-cli
sigma convert -t splunk -p sysmon Sigma/proc_powershell_encoded.yml
```

SPL equivalents are also noted in comments inside several rule files and in `../Splunk/searches/`.

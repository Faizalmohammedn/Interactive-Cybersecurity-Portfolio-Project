# Step 8 & 9 — Detection Rules + Incident Response

## Detection Rules

### Sigma

Rules live in [`../Sigma/`](../Sigma/). Convert to Splunk with [sigma-cli](https://github.com/SigmaHQ/sigma-cli) if desired:

```bash
pip install sigma-cli
sigma convert -t splunk -p sysmon Sigma/proc_powershell_encoded.yml
```

### YARA

Rules in [`../YARA/`](../YARA/). Test:

```bash
yara -r YARA/suspicious_exfil_staging.yar /path/to/samples
```

## Incident Response Process (Lab Playbook)

```
1. Detect   → Alert / dashboard anomaly
2. Triage   → Confirm true positive; scope hosts/users
3. Investigate → Splunk + PCAP + host artifacts
4. Contain  → Block attacker IP; disable account; isolate VM
5. Eradicate → Remove malware/scripts; reset credentials
6. Recover  → Restore from snapshot if needed
7. Lessons  → Update rules & documentation
```

## Containment Commands (Examples)

**Block Kali on target (iptables):**

```bash
sudo iptables -A INPUT -s 192.168.56.30 -j DROP
```

**Disable compromised local user (Windows):**

```powershell
Disable-LocalUser -Name labuser
# or reset password
```

**Revert to snapshot** if lab is heavily modified: VirtualBox → Snapshot → `baseline-clean`.

## Write the Report

Use templates in [`../Reports/`](../Reports/). Each IR report should include:

- Timeline
- Indicators of Compromise (IOCs)
- Splunk evidence queries
- Actions taken
- Recommendations

## MITRE ATT&CK Mapping (Lab)

| Attack | Tactic | Technique |
|--------|--------|-----------|
| Hydra SSH | Credential Access | T1110 Brute Force |
| Nmap | Discovery | T1046 Network Service Discovery |
| Encoded PowerShell | Execution / Defense Evasion | T1059.001 / T1027 |
| Data copy | Exfiltration | T1048 / T1020 (simulated) |

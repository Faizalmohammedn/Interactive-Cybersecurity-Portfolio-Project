# Lessons Learned

## What Worked Well

- **Sysmon + Splunk** made process and network telemetry easy to correlate for PowerShell and staging files.  
- **Small focused Sigma rules** mapped cleanly to Splunk alerts.  
- **Snapshots** let us recover quickly after destructive tests.  
- **Documenting IOCs early** sped up writing IR reports.

## Challenges

- Windows firewall / ICMP can hide hosts during discovery — document baseline firewall rules.  
- Splunk field names differ by TA (Technology Add-on); normalize searches for your apps (`Splunk_TA_windows`, Sysmon TA).  
- Full OpenVAS installs are heavy on RAM; Nmap alone is enough for a beginner portfolio if needed.  
- Large PCAPs do not belong in Git — store hashes and screenshots instead.

## Detection Gaps Observed

| Gap | Improvement |
|-----|-------------|
| No fail2ban on target | Add and alert on bans |
| Encoded PS without Script Block Logging | Enable Event Code 4104 |
| Exfil over approved protocols | Add size/rare-dest analytics |
| No DNS/HTTP proxy logs | Optional Squid or Zeek in v2 |

## Portfolio Improvements for v2

1. Add Zeek/Suricata on a monitoring TAP VM  
2. Automate UF install with Ansible  
3. Build a Splunk ES-like notable event workflow (even on Free)  
4. Map every alert to a written playbook  
5. Record a 3–5 minute demo video walkthrough  

## Key Takeaway

A SOC analyst’s value is not only running tools — it is **detecting, explaining, containing, and documenting** with clear evidence. This lab practices that full loop.

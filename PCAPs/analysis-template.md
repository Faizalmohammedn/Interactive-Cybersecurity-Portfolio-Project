# Sample PCAP Analysis Notes

Use this template after each capture (store hash next to ignored `.pcapng`).

## Capture Metadata

| Field | Value |
|-------|-------|
| File | `YYYYMMDD-scenario-host.pcapng` |
| SHA256 | _(paste)_ |
| Host NIC | Kali eth0 / Windows Host-Only |
| Duration | |
| Related IR | IR-00X |

## Observations

### Port scan

- SYN packets from `192.168.56.30` to many ports on target  
- Few completed handshakes  

### Brute force

- Repeated TCP/22 sessions  
- Short-lived connections until success  

### Exfiltration

- Large TCP stream length  
- Cleartext credentials? (lab HTTP only)

## Analyst Conclusion

_(1–3 sentences)_

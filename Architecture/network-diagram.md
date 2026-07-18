# Network Diagram (ASCII + Mermaid)

## ASCII Topology

```
                    [ Analyst Browser ]
                            |
                     https://192.168.56.10:8000
                            |
                     +------+-------+
                     |  Splunk SIEM |
                     |  .10         |
                     +------+-------+
                            ^
                            | UF / syslog
          +-----------------+-----------------+
          |                                   |
   +------+------+                     +------+------+
   | Windows 10  |                     | Ubuntu Tgt  |
   | Victim .20  |                     | Server .40  |
   +------+------+                     +------+------+
          ^                                   ^
          |          attacks                  |
          +---------------+-------------------+
                          |
                   +------+------+
                   | Kali Linux  |
                   | Attacker .30|
                   +-------------+
```

## Attack Paths

| Scenario | Source | Destination | Protocol |
|----------|--------|-------------|----------|
| Brute force SSH | Kali .30 | Target .40 | SSH / TCP 22 |
| Brute force RDP (optional) | Kali .30 | Victim .20 | RDP / TCP 3389 |
| Port scan | Kali .30 | Victim / Target | TCP/UDP various |
| Suspicious PowerShell | Local on Victim | n/a | Process create |
| Data transfer | Victim → Kali or Target | SMB/SCP/HTTP | TCP 445/22/80 |

## Packet Capture Placement

Capture on:

1. Kali (`eth0`) during attacks  
2. Windows (Npccap / Wireshark) for host view  
3. Optionally SIEM bridge if using a shared tap (advanced)

Store captures under `PCAPs/` with naming: `YYYYMMDD-scenario-host.pcapng`

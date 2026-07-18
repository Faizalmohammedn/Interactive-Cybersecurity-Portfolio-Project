# Step 6 — Wireshark / Packet Analysis

## Capture

On Kali during attacks:

```bash
sudo wireshark
# or
sudo tcpdump -i eth0 -w ~/captures/lab-session.pcapng
```

On Windows: install Npcap + Wireshark; capture on the Host-Only adapter.

## Display Filters (cheat sheet)

| Goal | Filter |
|------|--------|
| Traffic to/from victim | `ip.addr == 192.168.56.20` |
| SSH | `tcp.port == 22` |
| HTTP | `http` |
| DNS | `dns` |
| Possible scan (many SYN) | `tcp.flags.syn == 1 && tcp.flags.ack == 0` |
| Kali source | `ip.src == 192.168.56.30` |

More filters: [`../PCAPs/wireshark-filters.txt`](../PCAPs/wireshark-filters.txt)

## What to Document

### Port scan

- Many SYN packets from Kali to sequential or random ports
- Few completed handshakes; many RST/no response

### Brute force SSH

- Repeated SSH connections from Kali → Target
- Short-lived sessions until success

### Data transfer

- Large TCP stream (Follow → TCP Stream)
- SMB write or SCP/SFTP bulk transfer

## Portfolio Tip

Export a few annotated screenshots (Statistics → Conversations, I/O Graph) into `Screenshots/`. Do not commit huge PCAP binaries if GitHub size is a concern — document hashes instead:

```bash
sha256sum lab-session.pcapng > lab-session.pcapng.sha256
```

Next: [07-Vulnerability-Scanning.md](07-Vulnerability-Scanning.md)

# PCAPs

Store packet captures from attack exercises here.

## Naming Convention

```
YYYYMMDD-HHMM-scenario-host.pcapng
```

Examples:

- `20260718-1430-bruteforce-kali.pcapng`
- `20260718-1500-portscan-kali.pcapng`
- `20260718-1530-exfil-victim.pcapng`

## GitHub Note

Large binaries are gitignored (`*.pcap`, `*.pcapng`). Commit:

- This README  
- `wireshark-filters.txt`  
- `.sha256` sidecar files for evidence integrity  

```bash
sha256sum my.pcapng | tee my.pcapng.sha256
```

## Capture Tips

```bash
# Kali
sudo tcpdump -i eth0 host 192.168.56.40 -w bruteforce.pcapng

# Limit size
sudo tcpdump -i eth0 -C 50 -w lab-split.pcapng
```

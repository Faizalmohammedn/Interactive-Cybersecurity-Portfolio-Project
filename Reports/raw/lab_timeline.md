# Lab Attack Timeline (Generated)

- **2026-07-18T07:52:52.487656+00:00** — `soc-attacker` — Nmap SYN scan against soc-target (T1046)
- **2026-07-18T08:02:52.487656+00:00** — `soc-attacker` — Hydra SSH brute force against targetuser (T1110)
- **2026-07-18T08:07:52.487656+00:00** — `soc-target` — Successful SSH login after failures (T1078)
- **2026-07-18T08:17:52.487656+00:00** — `soc-victim` — Encoded PowerShell execution (T1059.001)
- **2026-07-18T08:27:52.487656+00:00** — `soc-victim` — Staged customer_export_fake.csv for exfil sim (T1074)

## IOCs

### ip_addresses
- `192.168.56.30`

### users
- `targetuser`
- `labuser`

### files
- `customer_export_fake.csv`
- `soc_lab_exfil_stage.txt`
- `staged_customer_export.csv`

### commands
- `powershell -EncodedCommand`
- `hydra -l targetuser -P wordlist-lab.txt ssh://192.168.56.40`
- `nmap -sS -sV`

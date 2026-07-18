# YARA Rules

| Rule | Purpose |
|------|---------|
| `suspicious_exfil_staging.yar` | Fake PII / staging markers from attack scripts |
| `suspicious_powershell_patterns.yar` | Encoded / download cradle patterns in scripts |

```bash
# Install yara then test against Temp staging file on victim
yara -r YARA/suspicious_exfil_staging.yar /tmp
yara -r YARA/suspicious_powershell_patterns.yar Scripts/attacks/
```

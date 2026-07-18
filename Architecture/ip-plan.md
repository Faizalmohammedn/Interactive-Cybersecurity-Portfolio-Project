# IP Addressing Plan

## Subnet

| Field | Value |
|-------|-------|
| Network | 192.168.56.0/24 |
| Usable | 192.168.56.2 – 192.168.56.254 |
| VirtualBox host | 192.168.56.1 |
| Broadcast | 192.168.56.255 |

## Static Assignments

| IP | Hostname | OS | Notes |
|----|----------|-----|-------|
| 192.168.56.10 | soc-siem | Ubuntu 22.04 | Splunk, optional OpenVAS |
| 192.168.56.20 | soc-victim | Windows 10 | Sysmon, UF, lab user `labuser` |
| 192.168.56.30 | soc-attacker | Kali rolling | Attack toolkit |
| 192.168.56.40 | soc-target | Ubuntu 22.04 | SSH + nginx demo site |

## Suggested Lab Accounts (change after clone)

| Host | Username | Password (lab only) | Purpose |
|------|----------|---------------------|---------|
| All Ubuntu | `socadmin` | `LabPass123!` | Admin |
| Windows | `labuser` | `Welcome1!` | Standard user |
| Windows | `Administrator` | `LabAdmin123!` | Admin (local) |
| Splunk Web | `admin` | set at install | SIEM |

> Weak passwords are intentional so Hydra demonstrations succeed. Do not reuse outside this lab.

## Connectivity Checklist

```bash
# From Kali
ping -c 2 192.168.56.10
ping -c 2 192.168.56.20
ping -c 2 192.168.56.40
nmap -sn 192.168.56.0/24
```

Expected: all four hosts respond (Windows may block ping until ICMP is allowed).

# Step 1 — Build the Lab (VirtualBox)

## Prerequisites

- Host PC with **≥ 16 GB RAM** recommended (8 GB minimum with light VMs)
- **≥ 80 GB** free disk
- VirtualBox 7.x + Extension Pack
- ISO images:
  - Ubuntu Server 22.04 LTS
  - Windows 10 (Evaluation or licensed)
  - Kali Linux

## Create Host-Only Network

1. VirtualBox → **File** → **Tools** → **Network Manager** → **Host-only Networks**
2. Create adapter `vboxnet0` (Windows may name it `VirtualBox Host-Only Ethernet Adapter`)
3. IPv4: `192.168.56.1` / `255.255.255.0`
4. Disable DHCP (we use static IPs) or leave DHCP for convenience and still set statics

## Create Four VMs

| VM Name | OS Type | RAM | vCPU | Disk | Network Adapter 1 |
|---------|---------|-----|------|------|-------------------|
| soc-siem | Ubuntu 64 | 4 GB | 2 | 40 GB | Host-Only |
| soc-victim | Windows 10 64 | 4 GB | 2 | 50 GB | Host-Only |
| soc-attacker | Debian 64 (Kali) | 2–4 GB | 2 | 40 GB | Host-Only |
| soc-target | Ubuntu 64 | 1–2 GB | 1 | 20 GB | Host-Only |

Optional Adapter 2 = NAT for updates; disconnect during attack labs.

## Ubuntu SIEM Install Notes

```bash
sudo hostnamectl set-hostname soc-siem
sudo nano /etc/netplan/00-installer-config.yaml
```

Example netplan:

```yaml
network:
  version: 2
  ethernets:
    enp0s3:
      addresses: [192.168.56.10/24]
      gateway4: 192.168.56.1
      nameservers:
        addresses: [8.8.8.8]
```

```bash
sudo netplan apply
sudo apt update && sudo apt upgrade -y
```

## Ubuntu Target

Same pattern with IP `192.168.56.40`. Install services:

```bash
sudo apt install -y openssh-server nginx
sudo systemctl enable --now ssh nginx
# Create weak lab user for Hydra demo
sudo adduser --gecos "" targetuser
# password: password123
```

## Windows Victim

1. Install Windows 10
2. Set hostname `soc-victim`
3. Static IP `192.168.56.20`
4. Create user `labuser` / `Welcome1!`
5. Allow ICMP (optional): Windows Firewall → Inbound → File and Printer Sharing (Echo Request)
6. Disable sleep; enable RDP only if you will demo RDP brute force

## Kali Attacker

1. Import Kali OVA or install from ISO
2. Static IP `192.168.56.30`
3. Update tools:

```bash
sudo apt update
sudo apt install -y hydra nmap wireshark python3-pip
```

## Verify Connectivity

From Kali:

```bash
ping -c 2 192.168.56.10
ping -c 2 192.168.56.40
nmap -sn 192.168.56.0/24
```

## Snapshot

Take a clean snapshot named `baseline-clean` on every VM before attacks.

Next: [02-Splunk-Install.md](02-Splunk-Install.md)

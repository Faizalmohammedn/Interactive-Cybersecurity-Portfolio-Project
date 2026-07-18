# Step 2 — Install Splunk Enterprise (Ubuntu SIEM)

## Download

1. Create a free Splunk account
2. Download **Splunk Enterprise** Linux `.tgz` (Free license / Trial)
3. Copy to SIEM: `scp splunk-*.tgz socadmin@192.168.56.10:~/`

## Install

```bash
cd ~
tar xvzf splunk-*.tgz
sudo mv splunk /opt/
sudo /opt/splunk/bin/splunk start --accept-license
```

Set admin password when prompted. Enable boot-start:

```bash
sudo /opt/splunk/bin/splunk enable boot-start
```

## Open Firewall Ports

```bash
sudo ufw allow 8000/tcp
sudo ufw allow 9997/tcp
sudo ufw allow 8089/tcp
sudo ufw enable
```

## Enable Receiving

Splunk Web → **Settings** → **Forwarding and receiving** → **Configure receiving** → Add port **9997**.

CLI alternative:

```bash
sudo /opt/splunk/bin/splunk enable listen 9997 -auth admin:YOUR_PASSWORD
```

## Indexes

Create indexes for lab data:

| Index | Purpose |
|-------|---------|
| `windows` | Windows Security / System |
| `sysmon` | Sysmon |
| `linux` | Target auth / syslog |
| `network` | Optional Zeek/firewall |

Web: **Settings** → **Indexes** → New Index

Or use app configs from [`../Splunk/inputs/`](../Splunk/inputs/).

## Verify UI

Browse to `http://192.168.56.10:8000` and log in as `admin`.

## Optional: Splunk on Free License

After trial, switch to Free license (indexing limit applies). Adequate for this lab.

Next: [03-Sysmon-Setup.md](03-Sysmon-Setup.md)

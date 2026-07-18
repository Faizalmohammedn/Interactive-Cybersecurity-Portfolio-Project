# Splunk Content

| Path | Contents |
|------|----------|
| `dashboards/` | Simple XML dashboards (login, suspicious, network) |
| `searches/core_searches.spl` | Copy/paste SPL for reports & alerts |
| `inputs/` | UF + indexer input examples |
| `props/` | Sourcetype props examples |

## Import Dashboards

1. Create app `soc_lab` or use Search & Reporting
2. Place XML under `$SPLUNK_HOME/etc/apps/<app>/local/data/ui/views/`
3. Restart Splunk or refresh views
4. Open from **Dashboards** menu

## Recommended Alerts

Convert these searches to alerts (cron every 5 minutes, throttle 1 hour):

- Encoded PowerShell  
- SSH failures > 10  
- Unique dest ports > 50 in 2 minutes  

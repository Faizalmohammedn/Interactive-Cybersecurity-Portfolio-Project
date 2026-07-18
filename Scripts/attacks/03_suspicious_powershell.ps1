# Attack 3: Suspicious PowerShell activity (LAB ONLY - run on Windows victim)
# Usage: powershell -ExecutionPolicy Bypass -File .\03_suspicious_powershell.ps1

[CmdletBinding()]
param(
    [switch]$SkipEncoded
)

$ErrorActionPreference = "Continue"
Write-Host "[*] SOC Lab - Suspicious PowerShell simulation" -ForegroundColor Yellow
Write-Host "[*] Host: $env:COMPUTERNAME | User: $env:USERNAME"

# --- Recon-like commands (common in intrusion kits) ---
Write-Host "`n[1] Local recon..." -ForegroundColor Cyan
whoami
hostname
Get-NetIPAddress -AddressFamily IPv4 | Select-Object IPAddress, InterfaceAlias | Format-Table
Get-Process | Select-Object -First 10 Name, Id | Format-Table
Get-LocalUser | Select-Object Name, Enabled | Format-Table

# --- Download cradle pattern (points at local lab target, not internet) ---
Write-Host "`n[2] Simulated download cradle (Invoke-WebRequest to lab HTTP)..." -ForegroundColor Cyan
try {
    Invoke-WebRequest -Uri "http://192.168.56.40/" -UseBasicParsing -TimeoutSec 5 | Select-Object StatusCode, StatusDescription
} catch {
    Write-Host "[!] Could not reach http://192.168.56.40/ (start nginx on target). $($_.Exception.Message)"
}

# --- Encoded PowerShell (defense evasion pattern) ---
if (-not $SkipEncoded) {
    Write-Host "`n[3] Encoded command execution..." -ForegroundColor Cyan
    $cmd = 'Write-Output "SOC-LAB-ENCODED-PAYLOAD"; Get-Date | Out-String'
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($cmd)
    $encoded = [Convert]::ToBase64String($bytes)
    powershell.exe -NoProfile -EncodedCommand $encoded
}

# --- Staging file (pairs with YARA rule) ---
Write-Host "`n[4] Creating staging marker file..." -ForegroundColor Cyan
$stage = Join-Path $env:TEMP "soc_lab_exfil_stage.txt"
@"
SOC-LAB-SENSITIVE-MARKER
employee_id=1001
ssn_fake=000-00-0000
credit_card_fake=4111111111111111
"@ | Set-Content -Path $stage -Encoding UTF8
Write-Host "[+] Wrote $stage"

Write-Host "`n[+] Done. Search Splunk: index=sysmon EventCode=1 Image=*powershell*" -ForegroundColor Green

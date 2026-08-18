# Windows SOC Lab - Splunk Universal Forwarder Setup
#
# Run this script from an elevated PowerShell session.
# The script configures the Universal Forwarder to collect
# Sysmon and PowerShell Operational events and forward them
# to the specified Splunk Enterprise server.

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

$SplunkHome = Join-Path $env:ProgramFiles "SplunkUniversalForwarder"
$SplunkBin = Join-Path $SplunkHome "bin"
$SplunkLocal = Join-Path $SplunkHome "etc\system\local"

Write-Host ""
Write-Host "============================================="
Write-Host " Windows SOC Lab - Universal Forwarder Setup"
Write-Host "============================================="
Write-Host ""

if (-not (Test-Path (Join-Path $SplunkBin "splunk.exe"))) {
    Write-Error "Splunk Universal Forwarder was not found at $SplunkHome"
    exit 1
}

Write-Host "Splunk Universal Forwarder found."
Write-Host ""

$SplunkServer = Read-Host "Enter Splunk Enterprise IP address or hostname"

if ([string]::IsNullOrWhiteSpace($SplunkServer)) {
    Write-Error "Splunk Enterprise address cannot be empty."
    exit 1
}

New-Item -ItemType Directory -Path $SplunkLocal -Force | Out-Null

$InputsConfig = @"
# Windows SOC Lab
# Splunk Universal Forwarder Inputs

[WinEventLog://Microsoft-Windows-Sysmon/Operational]
disabled = 0
index = main
renderXml = false
start_from = oldest

[WinEventLog://Microsoft-Windows-PowerShell/Operational]
disabled = 0
index = main
renderXml = false
start_from = oldest
"@

$OutputsConfig = @"
# Windows SOC Lab
# Splunk Universal Forwarder Outputs

[tcpout]
defaultGroup = default-autolb-group

[tcpout:default-autolb-group]
server = ${SplunkServer}:9997
"@

$InputsPath = Join-Path $SplunkLocal "inputs.conf"
$OutputsPath = Join-Path $SplunkLocal "outputs.conf"

$InputsConfig | Set-Content -Path $InputsPath -Encoding ASCII
$OutputsConfig | Set-Content -Path $OutputsPath -Encoding ASCII

Write-Host ""
Write-Host "Configuration files created:"
Write-Host "  $InputsPath"
Write-Host "  $OutputsPath"
Write-Host ""

$PowerShellLog = Get-WinEvent -ListLog "Microsoft-Windows-PowerShell/Operational"

if (-not $PowerShellLog.IsEnabled) {
    Write-Host "Enabling PowerShell Operational logging..."
    wevtutil set-log "Microsoft-Windows-PowerShell/Operational" /enabled:true
}
else {
    Write-Host "PowerShell Operational logging is already enabled."
}

Write-Host ""
Write-Host "Restarting Splunk Universal Forwarder..."

& (Join-Path $SplunkBin "splunk.exe") restart

if ($LASTEXITCODE -ne 0) {
    Write-Error "Splunk Universal Forwarder restart failed."
    exit 1
}

Write-Host ""
Write-Host "Checking Universal Forwarder status..."
& (Join-Path $SplunkBin "splunk.exe") status

Write-Host ""
Write-Host "Checking forwarding destination..."
& (Join-Path $SplunkBin "splunk.exe") list forward-server

Write-Host ""
Write-Host "============================================="
Write-Host " Setup completed"
Write-Host "============================================="
Write-Host ""
Write-Host "Splunk Enterprise: $SplunkServer`:9997"
Write-Host "Collected logs:"
Write-Host "  - Sysmon Operational"
Write-Host "  - PowerShell Operational"
Write-Host ""
Write-Host "Next: verify the events in Splunk Enterprise."

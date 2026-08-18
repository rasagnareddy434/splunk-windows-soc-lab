# Windows SOC Lab - Universal Forwarder Verification
#
# Run from an elevated PowerShell session after running setup-uf.ps1.
# The script checks the Universal Forwarder service, configuration,
# Windows event logs and network connectivity to Splunk Enterprise.

#Requires -RunAsAdministrator

$ErrorActionPreference = "Continue"

$SplunkHome = Join-Path $env:ProgramFiles "SplunkUniversalForwarder"
$SplunkBin = Join-Path $SplunkHome "bin"
$SplunkExe = Join-Path $SplunkBin "splunk.exe"
$LocalConfig = Join-Path $SplunkHome "etc\system\local"

Write-Host ""
Write-Host "============================================="
Write-Host " Windows SOC Lab - Verification"
Write-Host "============================================="
Write-Host ""

# -------------------------------------------------
# 1. Check Splunk Universal Forwarder
# -------------------------------------------------

Write-Host "[1/6] Checking Splunk Universal Forwarder..."

$Service = Get-Service SplunkForwarder -ErrorAction SilentlyContinue

if ($null -eq $Service) {
    Write-Host "FAIL - SplunkForwarder service was not found." -ForegroundColor Red
}
elseif ($Service.Status -eq "Running") {
    Write-Host "PASS - SplunkForwarder is running." -ForegroundColor Green
}
else {
    Write-Host "FAIL - SplunkForwarder exists but is not running." -ForegroundColor Red
}

# -------------------------------------------------
# 2. Check configuration files
# -------------------------------------------------

Write-Host ""
Write-Host "[2/6] Checking configuration files..."

$InputsPath = Join-Path $LocalConfig "inputs.conf"
$OutputsPath = Join-Path $LocalConfig "outputs.conf"

if (Test-Path $InputsPath) {
    Write-Host "PASS - inputs.conf found." -ForegroundColor Green
}
else {
    Write-Host "FAIL - inputs.conf not found." -ForegroundColor Red
}

if (Test-Path $OutputsPath) {
    Write-Host "PASS - outputs.conf found." -ForegroundColor Green
}
else {
    Write-Host "FAIL - outputs.conf not found." -ForegroundColor Red
}

# -------------------------------------------------
# 3. Validate Splunk configuration with btool
# -------------------------------------------------

Write-Host ""
Write-Host "[3/6] Validating Splunk input configuration..."

if (Test-Path $SplunkExe) {

    & $SplunkExe btool inputs list --debug 2>$null |
        Select-String "Microsoft-Windows-Sysmon|Microsoft-Windows-PowerShell"

    Write-Host ""
    Write-Host "Validating forwarding configuration..."

    & $SplunkExe btool outputs list --debug 2>$null |
        Select-String "tcpout|server"

}
else {
    Write-Host "FAIL - splunk.exe was not found." -ForegroundColor Red
}

# -------------------------------------------------
# 4. Check Sysmon Operational log
# -------------------------------------------------

Write-Host ""
Write-Host "[4/6] Checking Sysmon Operational log..."

$SysmonLog = Get-WinEvent -ListLog "Microsoft-Windows-Sysmon/Operational" -ErrorAction SilentlyContinue

if ($null -eq $SysmonLog) {
    Write-Host "FAIL - Sysmon Operational log was not found." -ForegroundColor Red
}
elseif ($SysmonLog.IsEnabled) {
    Write-Host "PASS - Sysmon Operational log is enabled." -ForegroundColor Green
    Write-Host "Events available: $($SysmonLog.RecordCount)"
}
else {
    Write-Host "FAIL - Sysmon Operational log is disabled." -ForegroundColor Red
}

# -------------------------------------------------
# 5. Check PowerShell Operational log
# -------------------------------------------------

Write-Host ""
Write-Host "[5/6] Checking PowerShell Operational log..."

$PowerShellLog = Get-WinEvent -ListLog "Microsoft-Windows-PowerShell/Operational" -ErrorAction SilentlyContinue

if ($null -eq $PowerShellLog) {
    Write-Host "FAIL - PowerShell Operational log was not found." -ForegroundColor Red
}
elseif ($PowerShellLog.IsEnabled) {
    Write-Host "PASS - PowerShell Operational log is enabled." -ForegroundColor Green
    Write-Host "Events available: $($PowerShellLog.RecordCount)"
}
else {
    Write-Host "FAIL - PowerShell Operational log is disabled." -ForegroundColor Red
}

# -------------------------------------------------
# 6. Test network connectivity to Splunk
# -------------------------------------------------

Write-Host ""
Write-Host "[6/6] Testing connection to Splunk Enterprise..."

$SplunkServer = Read-Host "Enter Splunk Enterprise IP address or hostname"

if (-not [string]::IsNullOrWhiteSpace($SplunkServer)) {

    $Connection = Test-NetConnection `
        -ComputerName $SplunkServer `
        -Port 9997 `
        -WarningAction SilentlyContinue

    if ($Connection.TcpTestSucceeded) {
        Write-Host "PASS - TCP 9997 is reachable on $SplunkServer." -ForegroundColor Green
    }
    else {
        Write-Host "FAIL - TCP 9997 is not reachable on $SplunkServer." -ForegroundColor Red
        Write-Host "Check the Splunk receiver configuration, firewall and network connectivity."
    }

}
else {
    Write-Host "SKIPPED - No Splunk Enterprise address was provided."
}

# -------------------------------------------------
# Summary
# -------------------------------------------------

Write-Host ""
Write-Host "============================================="
Write-Host " Verification completed"
Write-Host "============================================="
Write-Host ""
Write-Host "If all required checks show PASS, continue"
Write-Host "to Splunk Enterprise and verify that events"
Write-Host "are arriving in index=main."
Write-Host ""

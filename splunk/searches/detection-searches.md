# Splunk Detection Searches

This directory contains the SPL detection searches used in the Windows SOC lab.

## 1. Windows Failed Logon Detection

index=* EventCode=4625

## 2. Windows Successful Logon Detection

index=* EventCode=4624

## 3. Sysmon Process Creation Detection

index=* sourcetype="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1

## 4. PowerShell Activity Detection

index=* sourcetype="WinEventLog:Microsoft-Windows-PowerShell/Operational"

## 5. PowerShell Script Block Detection

index=* sourcetype="WinEventLog:Microsoft-Windows-PowerShell/Operational" EventCode=4104

## 6. Suspicious PowerShell Command Detection

index=* sourcetype="WinEventLog:Microsoft-Windows-PowerShell/Operational" (EventCode=4103 OR EventCode=4104) ("EncodedCommand" OR "FromBase64String" OR "Invoke-WebRequest" OR "DownloadString" OR "IEX" OR "Invoke-Expression")

## 7. Multiple Failed Logons / Brute-Force Detection

index=* EventCode=4625
| stats count as failed_attempts by host, Account_Name
| where failed_attempts >= 5
| sort - failed_attempts

## 8. Failed Logon Followed by Successful Logon

index=* (EventCode=4625 OR EventCode=4624)
| stats count(eval(EventCode=4625)) as failed_logons count(eval(EventCode=4624)) as successful_logons by host, Account_Name
| where failed_logons > 0 AND successful_logons > 0
| sort - failed_logons

## 9. Suspicious Process Execution

index=* sourcetype="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1 (Image="*\\powershell.exe" OR Image="*\\cmd.exe" OR Image="*\\wscript.exe" OR Image="*\\cscript.exe" OR Image="*\\mshta.exe")

## 10. Sysmon Process Creation by Host

index=* sourcetype="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1
| stats count as process_creations by host
| sort - process_creations

## 11. PowerShell Activity by Host

index=* sourcetype="WinEventLog:Microsoft-Windows-PowerShell/Operational"
| stats count as powershell_events by host
| sort - powershell_events

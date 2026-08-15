# Splunk Detection Searches

This document contains the Splunk searches used in the Windows SOC lab.

## Sysmon Process Creation

Event ID: 1

Detection:
index=* EventCode=1

## Sysmon Network Connection

Event ID: 3

Detection:
index=* EventCode=3

## Sysmon File Creation

Event ID: 11

Detection:
index=* EventCode=11

## Sysmon Registry Activity

Event IDs: 12, 13, 14

Detection:
index=* (EventCode=12 OR EventCode=13 OR EventCode=14)

## Sysmon DNS Query

Event ID: 22

Detection:
index=* EventCode=22

## Windows Failed Logon

Event ID: 4625

Detection:
index=* EventCode=4625

## PowerShell Activity

Source:
WinEventLog:Microsoft-Windows-PowerShell/Operational

Detection:
index=* source="WinEventLog:Microsoft-Windows-PowerShell/Operational"

## Scheduled Detection Alerts

The following scheduled alerts were configured in Splunk:

- SOC - Sysmon Process Creation
- SOC - Sysmon Network Connection
- SOC - Sysmon File Creation
- SOC - Sysmon Registry Activity
- SOC - Sysmon DNS Query
- SOC - PowerShell Activity
- SOC - Windows Failed Logon

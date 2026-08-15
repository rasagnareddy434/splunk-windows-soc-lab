# Detection Searches

SPL searches used during the Windows SOC lab for monitoring and investigating Windows, Sysmon and PowerShell activity.

## Windows Authentication

### Failed Logon — Event ID 4625

Used to identify failed Windows logon attempts.

    index=* EventCode=4625

Alert:
SOC - Windows Failed Logon

The alert is scheduled every 5 minutes and triggers when the search returns one or more results.

---

### Successful Logon — Event ID 4624

Used to review successful Windows authentication activity and correlate it with failed logons when investigating an account.

    index=* EventCode=4624

---

### Multiple Failed Logons

Used to identify accounts or hosts with repeated failed authentication attempts.

    index=* EventCode=4625
    | stats count as failed_attempts by host, Account_Name
    | where failed_attempts >= 5
    | sort - failed_attempts

The threshold of 5 is used for this lab and can be adjusted depending on the environment.

---

### Failed Logon Followed by Successful Logon

Used as an investigation query when an account has both failed and successful authentication activity during the selected time range.

    index=* (EventCode=4625 OR EventCode=4624)
    | stats count(eval(EventCode=4625)) as failed_logons count(eval(EventCode=4624)) as successful_logons by host, Account_Name
    | where failed_logons > 0 AND successful_logons > 0
    | sort - failed_logons

This is an investigation query rather than proof of compromise.

---

## Sysmon

### Process Creation — Event ID 1

Used to monitor processes created on the Windows endpoint.

    index=* sourcetype="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1

Useful fields during investigation include Image, CommandLine, ParentImage, ParentCommandLine, User and ProcessId.

Alert:
SOC - Sysmon Process Creation

---

### Network Connection — Event ID 3

Used to review network connections recorded by Sysmon.

    index=* sourcetype="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=3

Useful fields include Image, SourceIp, SourcePort, DestinationIp, DestinationPort and Protocol.

Alert:
SOC - Sysmon Network Connection

---

### File Creation — Event ID 11

Used to review files created on the endpoint.

    index=* sourcetype="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=11

This is useful when investigating newly created executables, scripts or files associated with suspicious process activity.

Alert:
SOC - Sysmon File Creation

---

### Registry Activity — Event IDs 12, 13 and 14

Used to review registry changes recorded by Sysmon.

    index=* sourcetype="WinEventLog:Microsoft-Windows-Sysmon/Operational" (EventCode=12 OR EventCode=13 OR EventCode=14)

This can be useful when investigating configuration changes and possible persistence-related activity.

Alert:
SOC - Sysmon Registry Activity

---

### DNS Query — Event ID 22

Used to review DNS queries made by processes on the endpoint.

    index=* sourcetype="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=22

Useful fields include QueryName, Image, User and ProcessId.

Alert:
SOC - Sysmon DNS Query

---

## PowerShell

### PowerShell Operational Activity

Used to review PowerShell activity collected from the Windows PowerShell Operational channel.

    index=* sourcetype="WinEventLog:Microsoft-Windows-PowerShell/Operational"

PowerShell activity is common on Windows systems, so the event should be reviewed together with the command, user, host and surrounding activity.

Alert:
SOC - PowerShell Activity

---

### PowerShell Script Block Logging — Event ID 4104

Used to review PowerShell script block events.

    index=* sourcetype="WinEventLog:Microsoft-Windows-PowerShell/Operational" EventCode=4104

Event ID 4104 is particularly useful during PowerShell investigations because the event can contain the script block content.

---

### Suspicious PowerShell Patterns

Used as an investigation query for PowerShell events containing commonly reviewed command patterns.

    index=* sourcetype="WinEventLog:Microsoft-Windows-PowerShell/Operational" (EventCode=4103 OR EventCode=4104) ("EncodedCommand" OR "FromBase64String" OR "Invoke-WebRequest" OR "DownloadString" OR "IEX" OR "Invoke-Expression")

A match is not automatically malicious. The surrounding event details and endpoint activity need to be reviewed before making a decision.

---

## Quick Investigation Searches

### Process Activity by Host

    index=* sourcetype="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1
    | stats count as process_creations by host
    | sort - process_creations

### PowerShell Activity by Host

    index=* sourcetype="WinEventLog:Microsoft-Windows-PowerShell/Operational"
    | stats count as powershell_events by host
    | sort - powershell_events

---

## Current Alert Coverage

The following searches have been configured as alerts in this lab:

- SOC - Windows Failed Logon
- SOC - Sysmon Process Creation
- SOC - Sysmon Network Connection
- SOC - Sysmon File Creation
- SOC - Sysmon Registry Activity
- SOC - Sysmon DNS Query
- SOC - PowerShell Activity

Alert results are reviewed in Splunk Triggered Alerts and can be investigated using the corresponding SPL searches above.

## Data Sources

Windows Security
    Event IDs: 4624, 4625

Sysmon Operational
    Event IDs: 1, 3, 11, 12, 13, 14, 22

PowerShell Operational
    Event IDs: 4103, 4104

## Notes

These searches were developed and tested against telemetry generated by the Windows endpoint in this lab. The queries are intended for lab learning and demonstration; thresholds and detection logic would need tuning before being used in a production environment.

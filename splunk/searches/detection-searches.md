# Splunk Detection Searches

This directory contains the SPL detection searches used in the Windows SOC Lab.

These detections monitor Windows endpoint activity collected by the Splunk Universal Forwarder and indexed by Splunk Enterprise.

---

# Alert Configuration

All seven detection searches use the following alert configuration:

- Alert Type: Scheduled
- Cron Schedule: `*/5 * * * *`
- Run Frequency: Every 5 minutes
- Time Range: Last 5 minutes
- Dispatch Earliest Time: `-5m`
- Dispatch Latest Time: `now`
- Trigger Condition: Number of Results
- Condition: Greater Than
- Threshold: `0`
- Status: Enabled
- Alert Actions: None configured

---

# 1. SOC - PowerShell Activity

## Purpose

Detect PowerShell activity collected from the Windows PowerShell Operational log.

## SPL

```spl
index=* source="WinEventLog:Microsoft-Windows-PowerShell/Operational"
```

## Alert Configuration

- Alert Type: Scheduled
- Cron Schedule: `*/5 * * * *`
- Time Range: Last 5 minutes
- Dispatch Earliest Time: `-5m`
- Dispatch Latest Time: `now`
- Trigger Condition: Number of Results
- Condition: Greater Than
- Threshold: `0`
- Status: Enabled
- Alert Actions: None configured

---

# 2. SOC - Sysmon DNS Query

## Purpose

Detect DNS query activity using Sysmon Event ID 22.

## SPL

```spl
index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=22
```

## Alert Configuration

- Alert Type: Scheduled
- Cron Schedule: `*/5 * * * *`
- Time Range: Last 5 minutes
- Dispatch Earliest Time: `-5m`
- Dispatch Latest Time: `now`
- Trigger Condition: Number of Results
- Condition: Greater Than
- Threshold: `0`
- Status: Enabled
- Alert Actions: None configured

---

# 3. SOC - Sysmon File Creation

## Purpose

Detect file creation activity using Sysmon Event ID 11.

## SPL

```spl
index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=11
```

## Alert Configuration

- Alert Type: Scheduled
- Cron Schedule: `*/5 * * * *`
- Time Range: Last 5 minutes
- Dispatch Earliest Time: `-5m`
- Dispatch Latest Time: `now`
- Trigger Condition: Number of Results
- Condition: Greater Than
- Threshold: `0`
- Status: Enabled
- Alert Actions: None configured

---

# 4. SOC - Sysmon Network Connection

## Purpose

Detect network connection activity using Sysmon Event ID 3.

## SPL

```spl
index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=3
```

## Alert Configuration

- Alert Type: Scheduled
- Cron Schedule: `*/5 * * * *`
- Time Range: Last 5 minutes
- Dispatch Earliest Time: `-5m`
- Dispatch Latest Time: `now`
- Trigger Condition: Number of Results
- Condition: Greater Than
- Threshold: `0`
- Status: Enabled
- Alert Actions: None configured

---

# 5. SOC - Sysmon Process Creation

## Purpose

Detect process creation activity using Sysmon Event ID 1.

## SPL

```spl
index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1
```

## Alert Configuration

- Alert Type: Scheduled
- Cron Schedule: `*/5 * * * *`
- Time Range: Last 5 minutes
- Dispatch Earliest Time: `-5m`
- Dispatch Latest Time: `now`
- Trigger Condition: Number of Results
- Condition: Greater Than
- Threshold: `0`
- Status: Enabled
- Alert Actions: None configured

---

# 6. SOC - Sysmon Registry Activity

## Purpose

Detect registry activity using Sysmon Event IDs 12, 13 and 14.

## SPL

```spl
index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode IN (12,13,14)
```

## Alert Configuration

- Alert Type: Scheduled
- Cron Schedule: `*/5 * * * *`
- Time Range: Last 5 minutes
- Dispatch Earliest Time: `-5m`
- Dispatch Latest Time: `now`
- Trigger Condition: Number of Results
- Condition: Greater Than
- Threshold: `0`
- Status: Enabled
- Alert Actions: None configured

---

# 7. SOC - Windows Failed Logon

## Purpose

Detect failed Windows authentication attempts using Windows Security Event ID 4625.

## SPL

```spl
index=* EventCode=4625
```

## Alert Configuration

- Alert Type: Scheduled
- Cron Schedule: `*/5 * * * *`
- Time Range: Last 5 minutes
- Dispatch Earliest Time: `-5m`
- Dispatch Latest Time: `now`
- Trigger Condition: Number of Results
- Condition: Greater Than
- Threshold: `0`
- Status: Enabled
- Alert Actions: None configured

---

# Detection Summary

| Detection | Log Source | Event ID |
|---|---|---:|
| SOC - PowerShell Activity | Windows PowerShell Operational | All |
| SOC - Sysmon DNS Query | Sysmon Operational | 22 |
| SOC - Sysmon File Creation | Sysmon Operational | 11 |
| SOC - Sysmon Network Connection | Sysmon Operational | 3 |
| SOC - Sysmon Process Creation | Sysmon Operational | 1 |
| SOC - Sysmon Registry Activity | Sysmon Operational | 12, 13, 14 |
| SOC - Windows Failed Logon | Windows Security | 4625 |

---

# Detection Schedule Summary

| Detection | Schedule | Time Range | Trigger | Status |
|---|---|---|---|---|
| SOC - PowerShell Activity | Every 5 minutes | Last 5 minutes | Results > 0 | Enabled |
| SOC - Sysmon DNS Query | Every 5 minutes | Last 5 minutes | Results > 0 | Enabled |
| SOC - Sysmon File Creation | Every 5 minutes | Last 5 minutes | Results > 0 | Enabled |
| SOC - Sysmon Network Connection | Every 5 minutes | Last 5 minutes | Results > 0 | Enabled |
| SOC - Sysmon Process Creation | Every 5 minutes | Last 5 minutes | Results > 0 | Enabled |
| SOC - Sysmon Registry Activity | Every 5 minutes | Last 5 minutes | Results > 0 | Enabled |
| SOC - Windows Failed Logon | Every 5 minutes | Last 5 minutes | Results > 0 | Enabled |

---

# Verification Searches

The following searches can be used in Splunk Search & Reporting to verify that the required telemetry is being received.

## PowerShell Activity

```spl
index=* source="WinEventLog:Microsoft-Windows-PowerShell/Operational"
```

## Sysmon DNS Query

```spl
index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=22
```

## Sysmon File Creation

```spl
index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=11
```

## Sysmon Network Connection

```spl
index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=3
```

## Sysmon Process Creation

```spl
index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode=1
```

## Sysmon Registry Activity

```spl
index=* source="WinEventLog:Microsoft-Windows-Sysmon/Operational" EventCode IN (12,13,14)
```

## Windows Failed Logon

```spl
index=* EventCode=4625
```

---

# Lab Detection Flow

```text
Windows Endpoint
       |
       | Windows Event Logs
       | PowerShell Operational Logs
       | Sysmon Operational Logs
       v
Splunk Universal Forwarder
       |
       | TCP 9997
       v
Splunk Enterprise
       |
       v
Detection Searches
       |
       +---- PowerShell Activity
       +---- Sysmon DNS Query
       +---- Sysmon File Creation
       +---- Sysmon Network Connection
       +---- Sysmon Process Creation
       +---- Sysmon Registry Activity
       +---- Windows Failed Logon
       |
       v
SOC Alerts
```

---

# Recreating the Detections

When this repository is cloned into another Windows SOC lab environment, the seven SPL searches can be recreated in Splunk Enterprise using the documented alert configuration.

Each search should be:

1. Created in Splunk Search & Reporting.
2. Saved as an alert.
3. Configured as a scheduled alert.
4. Scheduled using `*/5 * * * *`.
5. Configured with a last 5-minute search window.
6. Configured to trigger when the number of results is greater than `0`.
7. Enabled.

The current lab does not configure email, webhook or script actions for these alerts.

---

# Current Detection Coverage

The current detection set provides visibility into:

- PowerShell activity
- DNS queries
- File creation
- Network connections
- Process creation
- Registry activity
- Failed Windows authentication attempts

These detections provide the initial detection layer for the Windows SOC Lab.

# Lab Architecture

## Environment

This lab uses a Windows endpoint as the monitored system and a Splunk Enterprise server for log collection, searching, alerting, and visualization.

### Components

- Windows endpoint
- Splunk Universal Forwarder
- Splunk Enterprise
- Sysmon
- Windows Event Logs
- PowerShell Operational Logs

## Log Flow

Windows endpoint generates security and system events.

Sysmon and Windows Event Logs provide the endpoint telemetry, while PowerShell Operational logs provide visibility into PowerShell activity.

The Splunk Universal Forwarder collects the configured logs and forwards them to Splunk Enterprise.

Splunk Enterprise is used to search the incoming events, create scheduled detections, and display the collected activity through dashboards.

```text
Windows Endpoint
      |
      |-- Windows Security Logs
      |-- Sysmon
      |-- PowerShell Operational Logs
      |
      v
Splunk Universal Forwarder
      |
      v
Splunk Enterprise
      |
      |-- SPL Searches
      |-- Detection Alerts
      |-- SOC Dashboard
      |
      v
Security Monitoring

# Windows SOC Lab Setup

This directory contains the configuration required to build the Windows endpoint and Splunk Enterprise components of the lab.

The lab uses a Splunk Universal Forwarder on the Windows endpoint to collect security telemetry and forward it to Splunk Enterprise over TCP port 9997.

## Lab Flow

Windows Endpoint
    |
    | Windows Event Logs
    | Sysmon Operational Logs
    | PowerShell Operational Logs
    |
    v
Splunk Universal Forwarder
    |
    | TCP 9997
    v
Splunk Enterprise
    |
    +--> SPL Searches
    +--> Detection Alerts
    +--> Dashboards


## Components

| Component | Purpose |
|-----------|---------|
| Windows Endpoint | Generates Windows security and system activity |
| Sysmon | Provides detailed process, network, DNS, file and registry telemetry |
| PowerShell Operational Log | Provides PowerShell activity |
| Splunk Universal Forwarder | Collects and forwards Windows telemetry |
| Splunk Enterprise | Receives, searches, visualizes and detects events |

---

## 1. Prerequisites

Before starting, make sure the following are available:

- Windows endpoint
- Splunk Universal Forwarder installed on the Windows endpoint
- Splunk Enterprise installed on the receiving server
- Microsoft Sysmon installed and running
- Network connectivity between the Universal Forwarder and Splunk Enterprise
- TCP port 9997 available on the Splunk Enterprise server

The Splunk Enterprise server address used in the configuration should be replaced with the address of the server in your own environment.

---

## 2. Configure Splunk Enterprise Receiving

On the Splunk Enterprise server, create or edit:

```text
$SPLUNK_HOME/etc/system/local/inputs.conf

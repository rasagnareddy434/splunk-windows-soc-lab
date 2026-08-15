# Lab Architecture

## Overview

This lab implements a Windows SOC monitoring environment using Splunk Enterprise.

Windows endpoint telemetry is collected using Windows Event Logs, Sysmon, and PowerShell Operational logs. Splunk Universal Forwarder forwards the collected telemetry to Splunk Enterprise for analysis.

## Data Flow

```text
Windows Endpoint
      |
      +-- Windows Event Logs
      |
      +-- Sysmon Events
      |
      +-- PowerShell Operational Logs
      |
      v
Splunk Universal Forwarder
      |
      | Forwarded Telemetry
      v
Splunk Enterprise
      |
      +-- SPL Searches
      |
      +-- Detection Alerts
      |
      +-- SOC Dashboard
      |
      v
Security Monitoring

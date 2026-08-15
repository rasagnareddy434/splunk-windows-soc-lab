# Splunk Windows SOC Lab

A hands-on Security Operations Center (SOC) home lab built to simulate Windows security monitoring and detection using Splunk Enterprise.

## Project Overview

This project demonstrates the collection, forwarding, analysis, visualization, and alerting of Windows security telemetry in a Splunk-based SOC environment.

The lab focuses on monitoring Windows activity using:

- Splunk Enterprise
- Splunk Universal Forwarder
- Microsoft Sysmon
- Windows Event Logs
- PowerShell Operational Logs
- Splunk Search Processing Language (SPL)
- Scheduled Security Alerts
- SOC Monitoring Dashboards

## Lab Architecture

```text
Windows Endpoint
      |
      | Windows Event Logs
      | Sysmon Events
      | PowerShell Logs
      v
Splunk Universal Forwarder
      |
      | Forwarded Security Telemetry
      v
Splunk Enterprise
      |
      +----------------------+
      |                      |
      v                      v
    SPL Searches         Detection Alerts
      |                      |
      v                      v
   Dashboards          Triggered Alerts

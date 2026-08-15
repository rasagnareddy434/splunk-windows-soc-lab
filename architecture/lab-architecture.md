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

```text

## Components
Windows Endpoint

The Windows endpoint generates security and system telemetry.

Sysmon

Sysmon provides detailed endpoint telemetry including:

Process creation
Network connections
File creation
Registry activity
DNS queries
PowerShell

PowerShell Operational logs are collected to monitor PowerShell activity.

Windows Security Logs

Windows Security Event Logs are collected for authentication monitoring, including failed logon events.

Splunk Universal Forwarder

The Universal Forwarder collects the required Windows telemetry and forwards it to Splunk Enterprise.

Splunk Enterprise

Splunk Enterprise receives and analyzes the telemetry using SPL searches.

Detection searches are configured as scheduled alerts.


Detection Flow

Windows Activity
       ↓
Log Generation
       ↓
Universal Forwarder
       ↓
Splunk Enterprise
       ↓
SPL Detection Search
       ↓
Alert Condition
       ↓
Triggered Alert
       ↓
SOC Investigation

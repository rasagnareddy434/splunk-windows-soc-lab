# Splunk Detection Searches

This directory contains the SPL detection searches used in the Windows SOC lab.

## 1. Windows Failed Logon Detection

### Purpose

Detect failed Windows authentication attempts using Security Event ID 4625.

### SPL

```spl
index=* EventCode=4625
